#' Map signals over intervals.
#' 
#' @param x tbl of intervals
#' @param y tbl of signals
#' @param ... name-value pairs of summary functions like \code{\link{min}()}, 
#'   \code{\link{count}()}, \code{\link{concat}()}. colnames in values have .x 
#'   and .y suffixes.
#'   
#' @return \code{data_frame}
#'   
#' @examples
#' x <- tibble::frame_data(
#'  ~chrom, ~start, ~end,
#'  "chr1", 100, 250,
#'  "chr2", 250, 500)
#'  
#' y <- tibble::frame_data(
#'  ~chrom, ~start, ~end, ~value,
#'  "chr1", 100, 250, 10,
#'  "chr1", 150, 250, 20,
#'  "chr2", 250, 500, 500)
#' 
#' # Note colnames (except \code{chrom}) are suffixed \code{.x} and \code{.y}
#' 
#' # mean, median, sd etc
#' bed_map(x, y, sum = sum(value.y))
#' bed_map(x, y, min = min(value.y), max = max(value.y))
#' 
#' bed_map(x, y, concat(value.y))
#' bed_map(x, y, distinct(value.y))
#' bed_map(x, y, first(value.y))
#' bed_map(x, y, last(value.y))
#' 
#' bed_map(x, y, absmax = abs(max(value.y)))
#' bed_map(x, y, absmin = abs(min(value.y)))
#' bed_map(x, y, count = length(value.y))
#' bed_map(x, y, count_distinct = length(unique(value.y)))
#' 
#' # use decreasing = TRUE to reverse numbers
#' bed_map(x, y, distinct_num = distinct(sort(value.y)))
#' 
#' @export
bed_map <- function(x, y, ...) {

  res <- bed_intersect(x, y) %>%
    group_by(chrom, start.x, end.x) %>%
    summarize_(.dots = lazyeval::lazy_dots(...))

  res 
}

#' @export
#' @rdname bed_map
concat <- function(.data, sep = ',') {
  paste0(.data, collapse = sep)
}

#' @export
#' @rdname bed_map
distinct_only <- function(.data, sep = ',') {
  concat(unique(.data), sep = sep)
}

#' @export
#' @rdname bed_map
distinct <- function(.data, sep = ',') {
  concat(rle(.data)$values, sep = sep)
}

#' @export
#' @rdname bed_map
first <- function(.data) {
  head(.data, n = 1)
}

#' @export
#' @rdname bed_map
last <- function(.data) {
  tail(.data, n = 1)
}
