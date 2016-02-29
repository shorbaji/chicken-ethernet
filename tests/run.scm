(import chicken scheme)

(use test ethernet)

(test-group
 "basics"
 (test "read is complement of write"
       #t
       (let* ((f (make-ethernet-frame dst: '(255 255 255 255 255 255)
				      src: '(0 1 2 3 4 5)
				      ethertype: 65535
				      payload: "yo!"
				      dot1q: #f))
	      (r (with-input-from-string
		     (with-output-to-string
		       (lambda () (write-ethernet-frame f)))
		   (lambda () (read-ethernet-frame)))))
	 (and (equal? (ethernet-frame-dst f) (ethernet-frame-dst r))
	      (equal? (etherent-frame-src f) (ethernet-frame-src r))))))

(test-exit)
