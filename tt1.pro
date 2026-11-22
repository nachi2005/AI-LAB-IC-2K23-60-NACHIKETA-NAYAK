/* Intelligent Timetable Generator - Turbo Prolog 2.0 */

domains
  lecture  = l(symbol, symbol)
  lectures = lecture*
  entry    = e(symbol, symbol, symbol, symbol)
  entries  = entry*
  names    = symbol*

predicates
  nondeterm subject_data(symbol, symbol, integer)
  nondeterm room_data(symbol)
  nondeterm slot_data(symbol, string)
  nondeterm unavailable(symbol, symbol)
  nondeterm make_lectures(names, lectures)
  nondeterm add_lec(symbol, symbol, integer, lectures, lectures)
  nondeterm schedule(lectures, entries, entries)
  nondeterm free_ok(symbol, symbol, symbol, entries)
  nondeterm clash(symbol, symbol, symbol, symbol, symbol, symbol)
  nondeterm show_tt(entries)
  nondeterm member_entry(symbol, entries, symbol, symbol, symbol)
  nondeterm start_tt

clauses
  /* FACTS: subject, teacher, number of lectures */
  subject_data(ai,     teacher_a, 2).
  subject_data(python, teacher_b, 2).
  subject_data(dbms,   teacher_c, 1).

  /* FACTS: rooms */
  room_data(room101).
  room_data(room102).

  /* FACTS: time slots */
  slot_data(mon_9am,  "Monday 9 AM").
  slot_data(mon_10am, "Monday 10 AM").
  slot_data(tue_9am,  "Tuesday 9 AM").
  slot_data(tue_10am, "Tuesday 10 AM").
  slot_data(wed_9am,  "Wednesday 9 AM").

  /* FACT: teacher not available in a slot */
  unavailable(teacher_a, wed_9am).

  /* Build the list of lectures from subjects */
  make_lectures([], []).
  make_lectures([S|T], L) :-
      subject_data(S, Tr, N),
      make_lectures(T, Rest),
      add_lec(S, Tr, N, Rest, L).

  add_lec(_, _, 0, L, L) :- !.
  add_lec(S, Tr, N, Rest, [l(S,Tr)|L]) :-
      N > 0,
      N1 = N - 1,
      add_lec(S, Tr, N1, Rest, L).

  /* Clash rules */
  clash(Sl, T, _, Sl, T, _).
  clash(Sl, _, R, Sl, _, R).
  clash(Sl, _, _, Sl, _, _).

  free_ok(_, _, _, []).
  free_ok(Sl, T, R, [e(Sl2,_,T2,R2)|Rest]) :-
      not(clash(Sl, T, R, Sl2, T2, R2)),
      free_ok(Sl, T, R, Rest).

  /* Main scheduling using backtracking */
  schedule([], Done, Done).
  schedule([l(S,T)|Rest], Done, Final) :-
      slot_data(Sl, _),
      room_data(R),
      not(unavailable(T, Sl)),
      free_ok(Sl, T, R, Done),
      schedule(Rest, [e(Sl,S,T,R)|Done], Final).

  /* Output in slot order */
  member_entry(Sl, [e(Sl,S,T,R)|_], S, T, R).
  member_entry(Sl, [_|Rest], S, T, R) :-
      member_entry(Sl, Rest, S, T, R).

  show_tt(Result) :-
      slot_data(Sl, Label),
      member_entry(Sl, Result, S, T, R),
      write(Label, ": ", S, " | ", T, " | ", R), nl,
      fail.
  show_tt(_).

  start_tt :-
      makewindow(1, 7, 7, "TIMETABLE GENERATOR", 0, 0, 25, 80),
      write("TEST CASE 1: Normal case"), nl,
      write("GENERATED TIMETABLE"), nl, nl,
      make_lectures([ai, python, dbms], L),
      schedule(L, [], Result), !,
      show_tt(Result), nl,
      write("Status: Timetable generated without teacher or room clashes."), nl, nl,
      write("Press any key to go back..."),
      readchar(_).
  start_tt :-
      nl,
      write("Status: No valid timetable could be created."), nl, nl,
      write("Press any key to go back..."),
      readchar(_).

goal
  start_tt.
