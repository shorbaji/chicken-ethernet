(import chicken scheme)

(use test ethernet)

(test-group
 "basics"
 (test "read is complement of write"
       #t
       (let* ((f (make-ethernet-frame 60000
				      5
				      #f
				      65535
				      "yo!"))
	      (r (with-input-from-string
		     (with-output-to-string
		       (lambda () (write-ethernet-frame f)))
		   (lambda () (read-ethernet-frame)))))
	 (and (equal? (ethernet-frame-dst f) (ethernet-frame-dst r))
	      (equal? (ethernet-frame-src f) (ethernet-frame-src r))))))

(test-exit)
