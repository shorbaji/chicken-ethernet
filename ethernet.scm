(module ethernet
    (broadcast-mac make-ethernet-frame ethernet-frame-dst ethernet-frame-src ethernet-frame-ethertype
		   ethernet-frame-payload ethernet-frame-dot1q
		   read-ethernet-frame write-ethernet-frame
		   broadcast? multicast?)

  (import chicken scheme)
  (use srfi-1 extras data-structures)

  (define broadcast-mac '(255 255 255 255 255 255))

  (define (broadcast? mac)
    (eq? #xffffffffffff mac))

  (define (multicast? mac ethertype)
    (or (and (eq? ethertype #x0800)
	     (>= mac #x01005e000000)
	     (<= mac #x01005effffff))
	(and (eq? ethertype #x086dd)
	     (>= mac #x333300000000)
	     (<= mac #x3333ffffffff))))
  
  (define make-ethernet-frame list)
  (define ethernet-frame-dst first)
  (define ethernet-frame-src second)
  (define ethernet-frame-dot1q third)
  (define ethernet-frame-ethertype fourth)
  (define ethernet-frame-payload fifth)

  (define (mac-address->string mac)
    (string-intersperse (map (lambda (i)
			       (sprintf "~X" i))
			     (octets->int mac 6))
			":"))

  (define (octets->int octets)
    (fold (lambda (n acc) (+ n (* acc 256))) 0 octets))

  (define (int->octets i n)
    (unfold-right (lambda (x) (zero? (cdr x)))
		  (lambda (x) (remainder (car x) 256))
		  (lambda (x) (cons (quotient (car x) 256)
				    (- (cdr x) 1)))
		  (cons i n)))
  
  (define (read-octets n)
    (map char->integer (string->list (read-string n))))

  (define (write-octets ls)
    (write-string (list->string (map integer->char ls))))

  (define (read-mac) (octets->int (read-octets 6)))
  (define (write-mac mac) (write-octets (int->octets mac 6)))
  (define (read-dot1q) (read-octets 2))
  (define (write-dot1q dot1q) (and dot1q (write-octets dot1q)))
  
  (define (read-ethertype) (octets->int (read-octets 2)))
  (define (write-ethertype e) (write-octets (int->octets e 2)))

  (define read-payload read-string)
  (define write-payload write-string)

  (define (read-ethernet-frame #!optional (dot1q? #f))
    (let* ((dst (read-mac))
	   (src (read-mac))
	   (dot1q (and dot1q? (read-dot1q)))
	   (ethertype (read-ethertype))
	   (payload (read-payload)))
      (list dst src dot1q ethertype payload)))

  (define (write-ethernet-frame frame)
    (map (lambda (fn x)
	   (fn x))
	 `(,write-mac ,write-mac ,write-dot1q ,write-ethertype ,write-payload)
	 frame)))
