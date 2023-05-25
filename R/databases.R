#' Get a database as a data frame
#'
#' Returns all of the properties in a database as a data frame.
#'
#' @param id The ID of an individual database
#' @importFrom httr2 request req_headers req_url_path_append req_body_json req_perform resp_body_json
#' @importFrom purrr reduce map_dfr map_chr compose
#' @export
#' @examples
#' \dontrun{
#' # Find the ID of a specific database
#' db_id <- search_all("Customer DB")$id
#'
#' # Get that database
#' databases(db_id)
#' }
databases <- function(id) {
  rbj <- list()
  rbj_index <- 1

  req_temp <- request("https://api.notion.com") |>
    req_headers("Content-Type" = "application/json") |>
    req_headers("Authorization" = Sys.getenv("NOTION_IIS")) |>
    req_headers("Notion-Version" = "2022-06-28") |>
    req_url_path_append("v1") |>
    req_url_path_append("databases") |>
    req_url_path_append(id) |>
    req_url_path_append("query") |>
    req_body_json(list(
      page_size = 100
    ))

  rbj[[rbj_index]] <- req_temp |>
    req_perform() |>
    resp_body_json()

  while (rbj[[rbj_index]]$has_more) {
    rbj_index <- rbj_index + 1
    rbj[[rbj_index]] <- req_temp |>
      req_body_json(list(
        page_size = 100,
        start_cursor = rbj[[rbj_index - 1]]$next_cursor)) |>
      req_perform() |>
      resp_body_json()
  }

  if(length(rbj) > 1) {
    rbj_results <- reduce(rbj, function(x, y) c(x$results, y$results))
  } else {
    rbj_results <- rbj[[1]]$results
  }

  rbj_results |> map_dfr(function(x){
    map_chr(x$properties, compose(as.character, handle_property)) |> rev()
  })
}
