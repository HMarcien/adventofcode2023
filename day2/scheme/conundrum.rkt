#lang racket

(require rackunit)
(require algorithms)

(define input-data (file->lines "input"))
(define test-data (file->lines "input-test.txt"))

;;; Part 1
;; procesdures

(define game-rx (pregexp "Game\\s*(\\d+)"))
(define red-rx (pregexp "(?<!\\d)(?:[1-9]|1[0-2])(?= red)"))
(define green-rx (pregexp "(?<!\\d)(?:[1-9]|1[0-3])(?= green)"))
(define blue-rx (pregexp "(?<!\\d)(?:[1-9]|1[0-4])(?= blue)"))

(define (sum-id entries)
  (if (null? entries) 0
      (sum (map (lambda (entry)
                  (let ([id (last (regexp-match game-rx entry))])
                    (if (all? (map possible? (string-split entry ";")))
                        (string->number id)
                        0))) entries))))

(define (possible? chaine)
  (and (if (string-contains? chaine "blue") (regexp-match? blue-rx chaine) #t)
       (if (string-contains? chaine "green") (regexp-match? green-rx chaine) #t)
       (if (string-contains? chaine "red") (regexp-match? red-rx chaine) #t)))

(define (part1 input)
  (println (sum-id input)))

(part1 input-data)

;; tests
(check-equal? (sum-id test-data) 8 "The sum is 8")

(check-equal? (sum-id '()) 0 "The sum is 0 when no data fund")

(check > (sum-id input-data) 8 "The sum is bigger than 0 when input is not null")

;;; Part 2

(define (entry-power entry)
  (product (list (apply max (map string->number (regexp-match* #px"\\d+(?= red)" entry)))
                 (apply max (map string->number (regexp-match* #px"\\d+(?= green)" entry)))
                 (apply max (map string->number (regexp-match* #px"\\d+(?= blue)" entry))))))

(define (sum-power entries)
  (if (null? entries) 0
      (sum (map entry-power entries))))

;; tests
(check-equal? (sum-power test-data) 2286 "The sum is 8")


(define (part2 input)
  (println (sum-power input)))

(part2 input-data)
