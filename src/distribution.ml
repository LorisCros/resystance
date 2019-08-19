(** Manipulation statistical distributions. *)

(** Type of a distribution of integers. *)
type t =
  { cardinal : int
  (** Number of values in this distribution. *)
  ; values : int list
  (** Values of the distribution. *) }

(** [distribution d] is a smart constructor. *)
let distribution : t -> t = fun d ->
  { values = List.sort (+) d.values ; cardinal = d.cardinal }

(** [of_list l] creates a distribution from a list. *)
let of_list : int list -> t = fun l ->
  distribution { values = l ; cardinal = List.length l }

(** [init] creates an empty distribution with value [x]. *)
let empty : t =
  { cardinal = 0 ; values = [] }

(** [merge t u] merges two distributions [t] and [u] into one. *)
let merge : t -> t -> t = fun a b ->
  distribution { cardinal = a.cardinal + b.cardinal
               ; values = a.values @ b.values }

let percentile : int -> t -> int = fun k { cardinal ; values ; _ } ->
  if cardinal = 0 then 0 else
  let index = int_of_float ((float_of_int (k * cardinal)) /. 100.) in
  List.nth values index

let average : t -> float = fun d ->
  (float_of_int (List.fold_left (+) 0 d.values)) /. (float_of_int d.cardinal)

(** [sd d] computes the standard deviation of [d]. *)
let sd : t -> float = fun ({ values ; _ } as d) ->
  let avg = average d in
  let sqavg = average { d with values = List.map (fun x -> x * x) values } in
  sqrt @@ sqavg -. avg *. avg
