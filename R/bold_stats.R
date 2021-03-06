#' Get BOLD stats
#'
#' @export
#' @inheritParams bold_specimens
#' @param dataType (character) one of "overview" or "drill_down" (default).
#' "drill_down": a detailed summary of information which provides record 
#' counts by [BINs, Country, Storing Institution, Species]. "overview": 
#' the total counts of [BINs, Countries, Storing Institutions, Orders, 
#' Families, Genus, Species]
#' @references 
#' \url{http://v4.boldsystems.org/index.php/resources/api?type=webservices}
#'
#' @examples \dontrun{
#' x <- bold_stats(taxon='Osmia')
#' x$total_records
#' x$records_with_species_name
#' x$bins
#' x$countries
#' x$depositories
#' x$order
#' x$family
#' x$genus
#' x$species
#' 
#' # just get all counts
#' lapply(Filter(is.list, x), "[[", "count")
#' 
#' res <- bold_stats(taxon='Osmia', response=TRUE)
#' res$url
#' res$status_code
#' res$response_headers
#'
#' # More than 1 can be given for all search parameters
#' bold_stats(taxon=c('Coelioxys','Osmia'))
#'
#' ## curl debugging
#' ### These examples below take a long time, so you can set a timeout so that 
#' ### it stops by X sec
#' bold_stats(taxon='Osmia', verbose = TRUE)
#' # bold_stats(geo='Costa Rica', timeout_ms = 6)
#' }

bold_stats <- function(taxon = NULL, ids = NULL, bin = NULL, 
  container = NULL, institutions = NULL, researchers = NULL, geo = NULL, 
  dataType = "drill_down", response=FALSE, ...) {
  
  args <- bc(list(taxon = pipeornull(taxon), geo = pipeornull(geo), 
                  ids = pipeornull(ids), bin = pipeornull(bin), 
                  container = pipeornull(container), 
                  institutions = pipeornull(institutions), 
                  researchers = pipeornull(researchers), 
                  dataType = dataType, format = "json"))
  check_args_given_nonempty(args, c('taxon','ids','bin','container',
                                    'institutions','researchers','geo'))
  out <- b_GET(paste0(bbase(), 'API_Public/stats'), args, ...)
  if (response) return(out)
  jsonlite::fromJSON(out$parse("UTF-8"))
}
