#' List all users
#'
#' Get a data frame with the names, ids, and types of all users associated with
#' your account.
#'
#' @importFrom httr2 request req_user_agent req_headers req_url_path_append req_perform resp_body_json req_url_query
#' @importFrom dplyr tibble
#' @importFrom purrr map_dfr
#' @export
#' @examples
#' \dontrun{
#' users()
#' }
users <- function() {
  rbj <- list()
  rbj_index <- 1

  req_temp <- request("https://api.notion.com") |>
    req_user_agent("Nosh (https://github.com/seankross/nosh)") |>
    req_headers("Content-Type" = "application/json") |>
    req_headers("Authorization" = Sys.getenv("NOTION_IIS")) |>
    req_headers("Notion-Version" = "2022-06-28") |>
    req_url_path_append("v1") |>
    req_url_path_append("users") |>
    req_url_query(page_size = 100)

  rbj[[rbj_index]] <- req_temp |>
    req_perform() |>
    resp_body_json()

  while (rbj[[rbj_index]]$has_more) {
    rbj_index <- rbj_index + 1
    rbj[[rbj_index]] <- req_temp |>
      req_url_query(start_cursor = rbj[[rbj_index - 1]]$next_cursor) |>
      req_perform() |>
      resp_body_json()
  }

  if(length(rbj) > 1) {
    rbj_results <- reduce(rbj, function(x, y) c(x$results, y$results))
  } else {
    rbj_results <- rbj[[1]]$results
  }

  rbj_results |>
    map_dfr(\(x) tibble(name = x$name,
                        id = x$id,
                        type = x$type))
}
