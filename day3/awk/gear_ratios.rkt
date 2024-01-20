#lang racket

(require rackunit)
(require algorithms)

(define input-data (file->lines "input.txt"))
(define test-data (file->lines "input-test.txt"))
(define number-pattern (pregexp "\\d+"))
(define symbol-pattern (pregexp "[^\\.\\d]"))
(define symbols-table '())

;;; Main

;; pour la juxtaposion verticale:
;; - je valide la justaposition par inclusion et égalité
;; pour la juxtaposition diagonale
;; - je calcule la différence entre la position de debut et de fin de chaque
;; symbol elle doit etre inférieur ou égale à 1
;; Pour la justaposition verticale
;; - je test que la diffence entre la derniere position d'un symbol et la
;; premiere du symbol suivant ne dépasse pas 1
;;((1 . ((1 . 2) (3 . 6)))
;; (2 .  ((3 . 4) (10 . 12))))

(define (extract-symbols line)
  (map
   (lambda (chaine) (or (string->number chaine 10 'number-or-false) chaine))
   (regexp-match* number-pattern line)))

(define (extract-symbols-postion line)
  (regexp-match-positions* symbol-pattern line))

(define (line->positions line)
  '())

(define (get-vertical-adjacents previous-line position)
  '())

(define (get-previous-horizontal-adjacents current-line postion)
  '())

(define (get-previous-diagonal-adjacents previous-line position)
  '())

(define (get-next-diagonal-adjacents previous-line position)
  '())

(define (all-adjacents previous-line position)
  (flatten (get-vertical-adjacents previous-line position)
           (get-previous-diagonal-adjacents previous-line position)
           (get-next-diagonal-adjacents previous-line position)
           (get-previous-horizontal-adjacents previous-line)
           ()))

(define (position->number table position)
  (fl))

(define (parts-sum lines)
  (if (null? lines) 0
      (apply sum (map (curry position->number symbols-table)
                      (map all-adjacents (map line->positions lines))) )))

(define (parts-numbers-sum lines)
  (cond [(null? lines) 0]
        [else (for/sum ([line lines] [ind in-naturals])
                (let ([line-symbols (regexp-match-positions* symbol-pattern line)]
                      [line-number (regexp-match-positions* number-pattern line)])
                  ()))]))


  ;;; TEST

  (test-case "AOC Day 3 tests"
    (check-equal? (parts-sum "") 0 "0 quand l'entrée est vide")
    (check-equal? (parts-sum test-data) 4361))
