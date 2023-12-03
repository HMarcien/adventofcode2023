#lang racket

;;; racket

(define (total-calibration calibration-value-list)
  (if (null? calibration-value-list) 0
      (apply + (chaines->nombres calibration-value-list))))

(define (chaines->nombres chaines)
  "Fait correspondre une liste de chaine de caractère à un nombre de 2 chiffres
présents dans chaque chaine."
  (if (null? chaines) '()
      (map chaine->nombre chaines)))

(define (chaine->nombre chaine)
  "Retourne un nombre formé du premier et du dernier nombre identifié dans une
chaine de caractères"
  (if (not (string? chaine)) 0
      (nombres-a-deux-chiffres
       (map lettre-vers-chiffres
            (regexp-match* #rx"(?=(one|two|three|four|five|six|seven|eight|nine|[0-9]))"
                           chaine #:match-select cadr)))))

(define (nombres-a-deux-chiffres sequence)
  "Retourne un nombre formé du premier et du dernier nombre d'une liste de nombres."
  (if (or (not (list? sequence)) (null? sequence)) 0
      (let ((premier (first sequence)) (dernier (last sequence)))
        (if (= (length sequence) 1) (string->number (string-append premier premier))
            (string->number (string-append premier dernier))))))

(define (string-number? str)
  "Prédicat qui indique si une chaine de caratère correspond à un nombre."
  (number? (string->number str)))

(define (lettre-vers-chiffres nombre)
  "Transforme un nombre en lettre vers un nombre en chiffre"
  (if (string-number? nombre) nombre
      (cdr (assoc nombre number-alist))))

(define number-alist '(("one" . "1")
                       ("two" . "2")
                       ("three" . "3")
                       ("four" . "4")
                       ("five" . "5")
                       ("six" . "6")
                       ("seven" . "7")
                       ("eight" . "8")
                       ("nine" . "9")))

;  (define (main)
;    (let ((input (call-with-input-file "input.txt" get-string-all)))
;      (display (total-calibration (string-split input char-set:whitespace)))))
(define (main)
  (println (total-calibration (file->lines "input.txt"))))

(main)
