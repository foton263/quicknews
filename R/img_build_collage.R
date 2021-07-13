#' Aggregate images as collage.
#'
#' @name img_build_collage
#' @param dir Directory of images 
#' @param dimx Collage dimension on x-axis
#' @param dimy Collage dimension on y-axis
#' @param prefix File name prefix of images to include in collage
#' @return An image
#' 
#' @export
#' @rdname img_build_collage
#'
img_build_collage <- function(dir, 
                              dimx, 
                              dimy, 
                              prefix = NULL) {

  ### https://bigbinary.com/blog/configuring-memory-allocation-in-imagemagick

  invisible(gc(full=TRUE))

  files <- grep('jpeg', dir(dir, full.names = TRUE), value = T)

  if(is.null(prefix)) { ## this goes elsewhere --
    prefix <- paste0(stringi::stri_rand_strings(1, 3, '[A-Z]'),
                     stringi::stri_rand_strings(1, 3,'[0-9]'))
  } else{

    prefix <- gsub(' ', '', prefix)
    files <- grep(prefix, files, value = T)
  }

  square_pics <- dimx * dimy

  set.seed(11)
  files1 <- sample(files, square_pics)

  ## local temp storage --
  make_column <- function(i, files, dimy){
    x1 <- magick::image_read(files[(i * dimy + 1):((i + 1) * dimy)])
    x2 <- magick::image_append(x1, stack = TRUE)
    magick::image_write(x2, paste0(tempdir(), '/', prefix, "_cols", i, ".jpeg"))
  }

  purrr::walk(0: (dimx - 1), ## i
              make_column, ##
              files = files1,
              dimy = dimy)

  invisible(gc(full=TRUE))
  fs <- paste0(tempdir(), "/", prefix, "_cols", 0: (dimx - 1), ".jpeg")

  x3 <- magick::image_read(fs)

  x4 <- magick::image_scale(x3, "500x1000") ## scales columns
  pic <- magick::image_append(x4, stack = FALSE)
  ##unlink(temp, recursive = T)
  file.remove(grep('_cols', dir(tempdir(), full.names = TRUE), value = T))
  pic
}
