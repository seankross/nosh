# Given an entire property object, return a string
#' @importFrom purrr map_chr
handle_property <- function(prop) {
  result <- NULL

  if(prop$type == "checkbox") {
    result <- prop$checkbox
  } else if(prop$type == "created_by") {
    result <- prop$id
  } else if(prop$type == "created_time") {
    result <- prop$created_time
  } else if(prop$type == "date") {
    result <- prop$date$start
  } else if(prop$type == "email") {
    result <- prop$email
  } else if(prop$type == "files") {
    result <- length(prop$files)
  } else if(prop$type == "formula") {
    result <- prop[[prop$type]]
  } else if(prop$type == "last_edited_by") {
    result <- prop$last_edited_by$id
  } else if(prop$type == "last_edited_time") {
    result <- prop$last_edited_time
  } else if(prop$type == "multi_select") {
    result <- prop$multi_select |> map_chr(\(x) x$name) |> sort() |> paste0(collapse = "-")
  } else if(prop$type == "number") {
    result <- prop$number
  } else if(prop$type == "people") {
    result <- prop$people |> map_chr(\(x) x$name) |> sort() |> paste0(collapse = "-")
  } else if(prop$type == "phone_number") {
    result <- prop$phone_number
  } else if(prop$type == "relation") {
    result <- prop$relation |> map_chr(\(x) x$id) |> sort() |> paste0(collapse = "_")
  } else if(prop$type == "rollup") {
    result <- prop[[prop$type]]
  } else if(prop$type == "rich_text") {
    result <- prop$rich_text |> map_chr(\(x) x$plain_text) |> paste0(collapse = "")
  } else if(prop$type == "select") {
    result <- prop$select$name
  } else if(prop$type == "status") {
    result <- prop$status$name
  } else if(prop$type == "title") {
    result <- prop$title |> map_chr(\(x) x$plain_text) |> paste0(collapse = "")
  } else if(prop$type == "url") {
    result <- prop$url
  }

  ifelse(is.null(result), NA, result)
}
