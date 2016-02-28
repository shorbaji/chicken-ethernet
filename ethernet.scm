(module ethernet
    (broadcast-mac make-ethernet-frame ethernet-frame-dst ethernet-frame-src ethernet-frame-ethertype
		   ethernet-frame-payload ethernet-frame-dot1q
		   read-ethernet-frame write-ethernet-frame)

  (import chicken scheme)
  (use defstruct extras srfi-13)

  
  (define broadcast-mac '(255 255 255 255 255 255))

  (use defstruct)

  (defstruct ethernet-frame
    dst
    src
    ethertype
    payload (dot1q #f))

  (define (mac-address->string mac)
    (string-join (map (lambda (i)
			(sprintf "~X" i))
		      mac)
		 ":"))

  (define (read-octets n)
    (map char->integer (string->list (read-string n))))

  (define (write-octets ls)
    (write-string (list->string (map integer->char ls))))

  (define (read-mac) (read-octets 6))
  (define (write-mac mac) (write-octets mac))

  (define (read-dot1q) (read-octets 2))
  (define (write-dot1q dot1q) (and dot1q
				   (write-octets dot1q)))

  (define (read-ethertype)
    (let ((r (read-octets 2)))
      (+ (* 256 (car r)) (cadr r))))

  (define (write-ethertype e)
    (write-octets (list (quotient e 256)
			(remainder e 256))))

  (define read-payload read-string)
  (define write-payload write-string)

  (define (read-ethernet-frame #!optional (dot1q? #f))
    (let* ((dst (read-mac))
	   (src (read-mac))
	   (dot1q (and dot1q? (read-dot1q)))
	   (ethertype (read-ethertype))
	   (payload (read-payload)))
      (make-ethernet-frame dst: dst
			   src: src
			   ethertype: ethertype
			   payload: payload
			   dot1q: dot1q)))

  (define (write-ethernet-frame frame)
    (map (lambda (fn nth)
	   (fn (nth frame)))
	 (list write-mac write-mac write-dot1q write-ethertype write-payload)
	 (list ethernet-frame-dst ethernet-frame-src ethernet-frame-dot1q
	       ethernet-frame-ethertype ethernet-frame-payload))))
