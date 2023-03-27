#' jsonfilecreator UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_jsonfilecreator_ui <- function(id){
  ns <- NS(id)
  tagList(
    #titlePanel("JSON File Generator"),
    #sidebarLayout(
      #sidebarPanel(
    box(
      titlePanel("ecoPiBirdID - settings of the Pi"),
      #p("This is the content of"),
        textInput("device", "Audio device:", value = "hifiberry"),
        numericInput("gain", "Gain:", min = 5, max = 40, step = 1, value = "40"),
        textInput("output_dir", "Output directory:", value = "/home/pi/output/recordings/todo"),
        textInput("done_dir", "Done directory:", value = "/home/pi/output/recordings/done"),
        checkboxInput("keep_audio", "Keep audio:", value = TRUE)
      ),
      box(
        titlePanel("ecoPiBirdID - settings of the recordings"),
        selectInput("format", "Audio format:", choices = c("wav", "flac"), selected = "wav"),
        numericInput("duration", "Duration (seconds):", value = 1800),
        numericInput("max_file_time", "Max file time (seconds):", value = 600),
        selectInput("sample_rate", "Sample rate:", choices = c(24000, 32000, 44100, 48000, 88000, 96000), selected = 48000),
        selectInput("channels", "Number of channels:", choices = c(1,2), selected = 2),
        checkboxInput("save_as_mono", "Save as mono:", value = FALSE)
      ),
      box(
        titlePanel("ecoPiBirdID - settings of BirdNET"),
        textInput("i", "Input directory (birdnet):", value = "/home/pi/output/recordings/todo"),
        textInput("o", "Output directory (birdnet):", value = "/home/pi/output/detections"),
        textInput("slist", "Species list file (birdnet):", value = "/home/pi/config"),
        numericInput("min_conf", "Minimum confidence (birdnet):", min = 0.01, max = 0.999, step = 0.01, value = 0.7),
        numericInput("overlap", "Overlap (birdnet):", min = 0, value = 0),
        selectInput("rtype", "Result type (birdnet):", choices = c("r", "j"), selected = "r"),
        numericInput("threads", "Number of threads (birdnet):", min = 1, max = 4, step = 1, value = 3),
        numericInput("call_buffer", "Call buffer (species_of_interest):", value = 1),
        textInput("detections_dir", "Detections directory (species_of_interest):", value = "/home/pi/output/detections"),
        textInput("snippets_dir", "Snippets directory (species_of_interest):", value = "/home/pi/output/snippets")
      ),
      box(
        titlePanel("ecoPiBoom"),
        textInput("playback_file", "Playback file:", value = "playback/Flussseeschwalbe_stereo_1min35s.flac"),
        numericInput("playback_count", "Playback count:", min = 0, value = 0)
      )
      #)
    #)
  )
}

#' jsonfilecreator Server Functions
#'
#' @noRd
mod_jsonfilecreator_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_jsonfilecreator_ui("jsonfilecreator_1")

## To be copied in the server
# mod_jsonfilecreator_server("jsonfilecreator_1")
