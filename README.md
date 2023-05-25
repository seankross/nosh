# [nosh](https://www.merriam-webster.com/dictionary/nosh)

<!-- badges: start -->
[![R-CMD-check](https://github.com/seankross/nosh/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seankross/nosh/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Opinionated, lightweight, read-only Notion API access.

## Installation

You can install the latest development version:

``` r
remotes::install_github("seankross/nosh@main")
```

## Getting Started

To use Nosh you need to get your own Internal Integration Secret (IIS) from Notion
which is specific to your integration. To do this go to
[Notion Integrations](https://www.notion.so/my-integrations) and create a new
integration. Go to the **Secrets** page of your new integration and you should
see the IIS there. To make R aware of your IIS you need to set the environmental
variable `NOTION_IIS`. You can do this in your `.Renviron` or with this line of
code:

```r
Sys.setenv("NOTION_IIS" = "secret_5nLEIYqDd6o58gd1ZAPP4OMH9OnVozyhN9XQysN1nFE")
```

Your Notion integration is only aware of the pages and databases that you
explicitly give it access to. To give your integration access to a page or
database, go to that page or database, select the three dot icon in the 
upper-right, click **Add connections**, then find the name of your Notion
integration and click on it. Your integration (and R) is now able to access
that page or database.

Nosh has three main functions:

``` r
library(nosh)

# List all users
nosh::users()

# List all pages and databases
nosh::search_all()

# List only pages and databases that match a query
nosh::search_all("Customer DB")

# Get a database as you would see it in Notion as a data frame. First you need
# to get the specific database ID.
db_id <- nosh::search_all("Customer DB")$id

# Now get the database
nosh::databases(db_id)
```

## Strong opinions about this package:

1. This package will always only have read-only functionality.
2. Functions in this package will always only return data frames.
3. The number of functions and arguments in this package will always be small.

## Related work:

- https://github.com/Eflores89/notionR
