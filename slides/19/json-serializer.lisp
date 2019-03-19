(ql:quickload :closer-mop)

(defclass json-serializable (standard-class)
  ())
(defmethod sb-mop:validate-superclass
    ((class json-serializable) (superclass standard-class))
  t)
(defmethod sb-mop:validate-superclass
    ((class standard-class) (superclass json-serializable))
  t)

(defgeneric json-serialize (instance))

(deftype json ()
  '(or number
    string
    (member :true :false :null)
    (and symbol
     (not keyword))
    list
    hash-table))

(defun json-compatible-class-p (class)
  ;; (closer-mop:ensure-finalized class)
  (let* ((slots (sb-mop:class-slots class))
         (types (mapcar #'sb-mop:slot-definition-type slots)))
    (format t "~&~a ~a ~a" class slots 12 #|(sb-mop:class-finalized-p class)|#)
    (every (lambda (type)
             (subtypep type 'json))
           types)))

(defmethod initialize-instance ((class json-serializable) &rest args)
  (declare (ignore args))
  (format t "~&yes")
  (unless (json-compatible-class-p class)
    (error "class ~a is not JSON-compatible" class))
  (call-next-method))

(defclass point ()
  ((x :type number
      :initarg :x)
   (y :type number
      :initarg :y)
   ;; (z :type number)
   ;; (alpha :type number)
   ;; (beta :type number :initform 42)
   (name :type string
         :initarg :name))
  (:metaclass json-serializable))

(defclass 3dpoint (point)
  ((z :type number))
  (:metaclass json-serializable))

(defclass tagged-point (point)
  ((tag :type keyword))
  (:metaclass json-serializable))

;; (defclass tagged-point-2 (point)
;;   ((tag :type keyword))
;;   (:metaclass json-serializable))


(defclass nope ()
  ((non :type (eql :yolo)))
  (:metaclass json-serializable))


;;; NOTE tests
(defclass metafoo (standard-class) ())
(defmethod sb-mop:validate-superclass ((class metafoo)
                                       (superclass standard-class))
  t)
(defmethod sb-mop:validate-superclass ((class standard-class)
                                       (superclass metafoo))
  t)

(defmethod initialize-instance ((instance metafoo) &rest args)
  (declare (ignore args))
  (format t "~&LOL ~a" instance)
  (call-next-method))

(defclass foo () () (:metaclass metafoo))


;; (defmethod sb-mop:validate-superclass ((class json-serializable)
;;                                        (superclass (eql (find-class 'standard-object))))
;;   (json-compatible-class-p class))
;; (defmethod sb-mop:validate-superclass ((class json-serializable)
;;                                        (superclass json-serializable))
;;   (json-compatible-class-p class))
;; (defmethod sb-mop:validate-superclass ((class json-serializable)
;;                                        (superclass standard-class))
;;   nil)
