#' Search for pages and databases
#'
#' Specify a query to search all of the Notion pages and databases that you have
#' access to.
#'
#' @param query A string to search pages and databases. An empty string returns
#' all pages and databases you have access to (this is the default).
#' @importFrom httr2 request req_headers req_url_path_append req_body_json req_perform resp_body_json
#' @importFrom purrr reduce map_dfr
#' @importFrom tibble tibble
#' @export
#' @examples
#' \dontrun{
#' # Returns all pages and databases
#' search_all()
#'
#' # Returns only pages and databases matching the query
#' search_all("Customer DB")
#' }
search_all <- function(query = "") {
  rbj <- list()
  rbj_index <- 1

  req_temp <- request("https://api.notion.com") |>
    req_headers("Content-Type" = "application/json") |>
    req_headers("Authorization" = Sys.getenv("NOTION_IIS")) |>
    req_headers("Notion-Version" = "2022-06-28") |>
    req_url_path_append("v1") |>
    req_url_path_append("search") |>
    req_body_json(list(
      query = query,
      page_size = 100))

  rbj[[rbj_index]] <- req_temp |>
    req_perform() |>
    resp_body_json()

  while (rbj[[rbj_index]]$has_more) {
    rbj_index <- rbj_index + 1
    rbj[[rbj_index]] <- req_temp |>
      req_body_json(list(
        query = query,
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

  rbj_results |> map_dfr(\(x) tibble(object = x$object,
                                     id = x$id,
                                     property_names = list(names(x$properties)),
                                     properties = list(x$properties),
                                     url = x$url,
                                     created_time = x$created_time,
                                     last_edited_time = x$last_edited_time,
                                     created_by_id = x$created_by$id,
                                     last_edited_by_object = x$last_edited_by$object,
                                     last_edited_by_id = x$last_edited_by$id,
                                     cover = list(x$cover),
                                     icon = list(x$icon),
                                     parent_type = x$type,
                                     parent_database_id = x$database_id,
                                     archived = x$archived
  ))

}
