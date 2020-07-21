(defpackage plan-tree
  (:nicknames shop-extended-plan-tree)
  (:use common-lisp iterate)
  (:import-from :alexandria #:when-let)
  (:export #:dependency
           #:establisher
           #:consumer
           #:prop
           #:tree-node
           #:tree-node-task
           #:tree-node-expanded-task
           #:tree-node-dependencies
           #:tree-node-parent
           #:primitive-tree-node
           #:make-primitive-tree-node
           #:complex-tree-node
           #:make-complex-tree-node
           #:complex-tree-node-children
           #:top-node
           #:make-top-node
           #:pseudo-node
           #:unordered-tree-node
           #:make-unordered-tree-node
           #:make-ordered-tree-node
           #:ordered-tree-node
           #:make-dependency
           ;; finders
           #:find-plan-step
           #:find-task-in-tree
           #:find-tree-node-if
           ))

(in-package :plan-tree)


;;;---------------------------------------------------------------------------
;;; Helpers for MAKE-LOAD-FORM for the plan tree.
;;;---------------------------------------------------------------------------

(defvar *table-for-load-form*)
(defvar *node-list*)

(defgeneric make-instantiator (obj)
  (:documentation "Return an s-expression instantiating a copy of OBJ.
The returned form will *not* include links to other objects to make the
result loadable")
  (:method (obj)
    (error "No method for instantiating object ~s" obj))
  (:method ((obj symbol))
    (cond ((eq obj :init) :init)
          ((equalp (symbol-name obj) (symbol-name '#:top))
           `(quote ,obj))
          (t (error "Unexpected symbol in plan tree: ~s" obj))))
  (:method ((obj list))
    "LISTS should be tasks or propositions"
    `(quote ,obj)))

(defgeneric cross-links-for (varname val table)
  (:documentation "Return a list of forms that set any
cross-links for VAL using information in TABLE."))

(defgeneric slot-fillers (obj)
  (:method (obj)
    (error "No method for computing slot fillers for object ~s" obj)))

;;;---------------------------------------------------------------------------
;;; 
;;;---------------------------------------------------------------------------


(defstruct (dependency (:conc-name nil))
  establisher
  consumer
  prop
  )

(defmethod make-instantiator ((obj dependency))
  `(make-dependency :prop ,(slot-value-translator
                            (prop obj))))

(defmethod cross-links-for ((var-name symbol) (obj dependency) (table hash-table))
  `((setf (consumer ,var-name) ,(slot-value-translator (consumer obj) table)
          (establisher ,var-name) ,(slot-value-translator (establisher obj) table))))

;;; this is an "abstract" class and should never be directly instantiated --
;;; only primitive-tree-node and complext-tree-node should be instantiated.
(defstruct tree-node
  task
  expanded-task
  dependencies ;; what does this tree node depend on -- dependencies IN
  parent
  )

(defmethod cross-links-for ((var-name symbol) (obj tree-node) (table hash-table))
  `((setf (tree-node-dependencies ,var-name)
          (list
           ,@(mapcar #'(lambda (x) (slot-value-translator x table))
                     (tree-node-dependencies obj))))))

(defstruct (primitive-tree-node (:include tree-node))
  )

(defun slot-value-translator (val &optional (table *table-for-load-form*))
  (cond ((null val) NIL)
        ((and (symbolp val)
              (or (eq val :INIT) (equalp (symbol-name val) (symbol-name '#:top))))
         val)
        (t (or (gethash val table)
               (error "No table entry for value ~s" val)))))

(defmethod slot-fillers ((obj tree-node))
  `(:task
    ,(slot-value-translator (tree-node-task obj))
    :expanded-task
    ,(slot-value-translator (tree-node-task obj))))

(defun make-cross-links (&optional (table *table-for-load-form*))
  (iter (for (val var) in-hashtable table)
    (unless (listp val)
     (appending 
      (cross-links-for var val table)))))

(defmethod make-instantiator ((obj primitive-tree-node))
  `(make-primitive-tree-node ,@ (slot-fillers obj)))

(defstruct (complex-tree-node (:include tree-node))
  children
  (method-name nil :type (or null symbol)))

(defmethod make-instantiator ((obj complex-tree-node))
  `(make-complex-tree-node ,@ (slot-fillers obj)))

(defmethod cross-links-for ((var-name symbol) (obj complex-tree-node) (table hash-table))
  (append (call-next-method)
          `((setf (complex-tree-node-children ,var-name)
                  (list 
                   ,@(mapcar #'(lambda (x) (slot-value-translator x table))
                           (complex-tree-node-children obj)))))))


(defstruct (top-node (:include complex-tree-node))
  ;; table from plan s-expressions to nodes.
  (lookup-table nil :type (or hash-table null)))

(defmethod make-instantiator ((obj top-node))
  `(make-top-node ,@ (slot-fillers obj)))

(defmethod slot-fillers ((obj top-node))
  (let ((slot-fillers (call-next-method)))
    (remf slot-fillers :task)
    (remf slot-fillers :expanded-task)
    (append `(:task (quote ,(top-node-task obj)))
            slot-fillers)))

(defmethod make-load-form ((obj top-node) &optional environment)
  (declare (ignorable environment))
  (let ((*table-for-load-form* (make-hash-table :test #'eq))
        (*node-list* nil))
    (make-table-entries obj)
    `(let* ,(obj-bindings *table-for-load-form*)
       ,@(make-cross-links *table-for-load-form*)
       ,(gethash obj *table-for-load-form*))))

(defgeneric make-table-entries (node)
  (:documentation "Traverse the plan tree, populating *TABLE-FOR-LOAD-FORM* dynamic variable
and building a toplogically sorted list of nodes."))

(defun obj-bindings (hash-table)
  "Return an ordered list of variable-name instantiator pairs for use in a LET form."
  (append 
   (iter (for (item var-name) in-hashtable hash-table)
     ;; proposition or task
     (when (listp item)
       (collecting `(,var-name ',item))))
   (iter (for (item var-name) in-hashtable hash-table)
     (unless (listp item)
       (collecting `(,var-name ,(make-instantiator item)))))))



(defun insert-if-necessary (obj &optional (table *table-for-load-form*))
  "Make an entry in TABLE for OBJ if it's not already there."
  (unless (eq obj :init)
    (unless (gethash obj table nil)
      (setf (gethash obj table)
            (cond ((typep obj 'tree-node)
                   (gensym "NODE"))
                  ((typep obj 'dependency)
                   (gensym "DEP"))
                  ((listp obj)
                   (gensym "PROP"))
                  (t (gensym "OTHER")))))))

(defmethod make-table-entries ((obj tree-node))
  (push obj *node-list*)
  (insert-if-necessary obj)
  (when-let (task (tree-node-task obj))
    ;; avoid TOP symbol
    (unless (symbolp task)
      (insert-if-necessary task)))
  (when-let (etask (tree-node-expanded-task obj))
    (unless (symbolp etask)
      (insert-if-necessary etask)))
  (when-let (parent (tree-node-parent obj))
    (insert-if-necessary parent))
  (iter (for dep in (tree-node-dependencies obj))
    (make-table-entries dep)))


(defmethod make-table-entries ((obj dependency))
  (insert-if-necessary obj)
  (unless (eq (establisher obj) :init)
    (insert-if-necessary (establisher obj)))
  (insert-if-necessary (consumer obj))
  (insert-if-necessary (prop obj)))


(defmethod make-table-entries ((obj complex-tree-node))
  (call-next-method)
  (mapc #'make-table-entries (complex-tree-node-children obj)))

(defstruct (pseudo-node (:include complex-tree-node)))

;;; maybe should revise this and have complex-tree-node as mixin, since
;;; ordered-tree-node and unordered-tree-node have neither TASK nor
;;; DEPENDENCIES.
(defstruct (ordered-tree-node (:include pseudo-node)))

(defstruct (unordered-tree-node (:include pseudo-node)))

;;; FIXME: this could probably be expanded to also emit the
;;; PRINT-OBJECT method header, instead of just the code that goes in
;;; it.
(defmacro print-unreadably ((&rest args) &body body)
  "This macro is for defining a method for printing un-readably, and
deferring to the built-in method when trying to print readably.
Particularly useful for structures, but could be generally applicable."
  `(if *print-readably*
       (call-next-method)
       (print-unreadable-object ,args
         ,@body)))


(defmethod print-object ((d dependency) str)
  (print-unreadably (d str)
    (if (eq (establisher d) :init)
        (format str "init")
        (format str "~A"
                (tree-node-task (establisher d))))
    (format str " -> ~A"
            (prop d))))

(defmethod print-object ((d primitive-tree-node) str)
  (print-unreadably (d str)
    (format str "Primitive: ~S"
            (or (tree-node-expanded-task d) (tree-node-task d)))
    #+ignore(when (tree-node-dependencies d)
      (format str " :DEPENDENCIES ~S "(tree-node-dependencies d)))))

(defmethod print-object ((d top-node) str)
  (print-unreadably (d str)
    (format str " TOP-NODE CHILDREN: ~A"
            (complex-tree-node-children d))))


(defmethod print-object ((d complex-tree-node) str)
  (print-unreadably (d str)
    (format str "Complex: ~S :CHILDREN ~A"
            (or (tree-node-expanded-task d)
                (tree-node-task d))
            (complex-tree-node-children d))
    #+ignore(when (tree-node-dependencies d)
      (format str " :DEPENDENCIES ~S "(tree-node-dependencies d)))))


(defmethod print-object ((d ordered-tree-node) str)
  (print-unreadably (d str)
    (format str "Ordered CHILDREN: ~A"
            (complex-tree-node-children d))))

(defmethod print-object ((d unordered-tree-node) str)
  (print-unreadably (d str :type t)
    (format str "Unordered CHILDREN: ~A"
            (complex-tree-node-children d))))
           
(defun find-plan-step (task plan-tree &optional plan-tree-hash)
  (labels ((tree-search (plan-tree)
             (etypecase plan-tree
               (primitive-tree-node
                (when (eq task (tree-node-task plan-tree))
                  plan-tree))
               (complex-tree-node
                (iter (for tree-node in (complex-tree-node-children plan-tree))
                  (as result = (tree-search tree-node))
                  (when result (return result))
                  (finally (return nil)))))))
    (or
     (if plan-tree-hash
         (find-task-in-tree task plan-tree-hash)
         (tree-search plan-tree))
     (error "No tree node for task ~S in ~S" task plan-tree))))

(defun find-task-in-tree (task &optional hash-table plan-tree)
  "Return the PLAN-TREE:TREE-NODE in TREE corresponding to TASK."
  (let ((task (shop2::strip-task-sexp task)))
    (cond (hash-table
           (or
            (gethash task hash-table)
            (error "No plan tree node for task ~S" task)))
          (plan-tree
           (labels ((tree-search (plan-tree)
                      (if (or (eq task (tree-node-task plan-tree))
                              (eq task (tree-node-expanded-task plan-tree)))
                          plan-tree
                          (etypecase plan-tree
                            (primitive-tree-node nil)
                            (complex-tree-node
                             (iter (for tree-node in (complex-tree-node-children plan-tree))
                                   (as result = (tree-search tree-node))
                                   (when result (return-from find-task-in-tree result))))))))
             (or
              (tree-search plan-tree)
              (error "No plan tree node for task ~S" task))))
          (t (error "Must pass either hash-table or plan-tree to FIND-TASK-IN-TREE.")))))

(defun find-tree-node-if (function plan-tree)
  (labels ((tree-search (plan-tree)
             (if (funcall function plan-tree)
                 plan-tree
                 (etypecase plan-tree
                   (primitive-tree-node nil)
                   (complex-tree-node
                    (iter (for tree-node in (complex-tree-node-children plan-tree))
                      (as result = (tree-search tree-node))
                      (when result (return-from find-tree-node-if result))))))))
    (tree-search plan-tree)))
