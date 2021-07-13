#' Download images from urls.
#'
#' @name img_download_images
#' @param link URL of image 
#' @param dir Directory to download images
#' @param prefix File name prefix for downloaded images
#' @param scale_border Boolean, scale images and add border
#' @return Image files
#'
#'
#' @export
#' @rdname img_download_images
#'
#'
img_download_images <- function(link, 
                                dir, 
                                prefix, 
                                scale_border = T) {
  for (i in 1:length(link)) {
    invisible(gc(full=TRUE))
    #temp <- tempfile()
    fname <- paste0(dir, '/', gsub(' ', '', prefix), i, '.jpeg')
    utils::download.file(link[i], fname, mode = 'wb')

    if(scale_border) {
      y1 <- magick::image_read(fname)
      y2 <- magick::image_scale(y1, "1000")
      y3 <- magick::image_border(y2, 'white', '10x10')

      magick::image_write(y3, fname)
    }
  }
  unlink(dir)
}
