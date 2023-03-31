#' jsonfilecreator UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import dplyr
#' @import shiny
#' @import shinyjs
#' @import readxl
#' @import jsonlite
mod_jsonfilecreator_ui <- function(id){
  ns <- NS(id)
  tagList(
    box(
      titlePanel("Settings"),
      box(
        titlePanel("ecoPiBirdID - settings of the Pi"),
          textInput(ns("device"), "Audio device:", value = "hifiberry"),
          numericInput(ns("gain"), "Gain:", min = 5, max = 40, step = 1, value = "40"),
          textInput(ns("output_dir"), "Recordings output directory:", value = "/home/pi/output/recordings/todo"),
          textInput(ns("done_dir"), "Recordings done directory:", value = "/home/pi/output/recordings/done"),
          checkboxInput(ns("keep_audio"), "Keep audio:", value = TRUE)
        ),
        box(
          titlePanel("ecoPiBirdID - settings of the recordings"),
          selectInput(inputId = ns("format"), "Audio format:", choices = c("wav", "flac"), selected = "wav"),
          numericInput(inputId = ns("mduration"), "Monitoring duration (seconds):", value = 1800),
          numericInput(inputId = ns("rduration"), "Recording duration (seconds):", value = 1800),
          numericInput(inputId = ns("max_file_time"), "Max file time (seconds):", value = 600),
          selectInput(inputId = ns("sample_rate"), "Sample rate:", choices = c(24000, 32000, 44100, 48000, 88000, 96000), selected = 48000),
          selectInput(inputId = ns("channels"), "Number of channels:", choices = c(1,2), selected = 2),
          checkboxInput(inputId = ns("save_as_mono"), "Save as mono:", value = TRUE)
        ),
        box(
          titlePanel("ecoPiBirdID - settings of BirdNET"),
          textInput(ns("i"), "Input directory (birdnet):", value = "/home/pi/output/recordings/todo"),
          textInput(ns("o"), "Output directory (birdnet):", value = "/home/pi/output/detections"),
          textInput(ns("slist"), "Species list file (birdnet):", value = "/home/pi/config"),
          numericInput(ns("min_conf"), "Minimum confidence (birdnet):", min = 0.01, max = 0.99, step = 0.01, value = 0.7),
          numericInput(ns("overlap"), "Overlap (birdnet):", min = 0, value = 0),
          selectInput(ns("rtype"), "Result type (birdnet):", choices = c("r"), selected = "r"),
          numericInput(ns("threads"), "Number of threads (birdnet):", min = 1, max = 4, step = 1, value = 3),
          numericInput(ns("call_buffer"), "Call buffer (species_of_interest):", value = 1),
          textInput(ns("detections_dir"), "Detections directory (species_of_interest):", value = "/home/pi/output/detections"),
          textInput(ns("snippets_dir"), "Snippets directory (species_of_interest):", value = "/home/pi/output/snippets")
        ),
        box(
          titlePanel("ecoPiBoom"),
          textInput(ns("playback_file"), "Playback file:", value = "playback/Flussseeschwalbe_stereo_1min35s.flac"),
          numericInput(ns("playback_count"), "Playback count:", min = 0, value = 0)
        )
      ),
    fluidRow(
      column(
        width = 6,
        titlePanel("Species List - detection list"),
        fluidRow(
          column(width = 6,
                 checkboxGroupInput(
                   inputId = ns("filter_abundance"),
                   label = "Filter abundance",
                   choices = list(
                     "Escapee" = "0",
                     "Common" = "1",
                     "Less common" = "2",
                     "Rare" = "3",
                     "Extremely rare" = "4"
                   ),
                   selected = c("1", "2")
                 )
          ),
          column(width = 6,
                 checkboxGroupInput(
                   inputId = ns("filter_region"),
                   label = "Filter region",
                   choices = list(
                     "WP" = "wp",
                     "Central Europe" = "ce",
                     "southern Germany" = "sg",
                     "northern Germany" = "ng"
                   ),
                   selected = c("ce")
                 )
          )
        ),
        selectInput(
          inputId = ns("selected_species_dl"),
          label = "Choose species",
          choices = readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
            dplyr::filter(!is.na(deutscher.name)) %>%
            dplyr::select(deutscher.name) %>%
            dplyr::arrange(deutscher.name) %>%
            dplyr::rename(" " = 1),
          multiple = TRUE,
          selectize = TRUE
        ),
        titlePanel("Species List - Files to send"),
        fluidRow(
          column(width = 6,
                 checkboxGroupInput(
                   inputId = ns("filter_abundance_fts"),
                   label = "Filter abundance",
                   choices = list(
                     "Escapee" = "0",
                     "Common" = "1",
                     "Less common" = "2",
                     "Rare" = "3",
                     "Extremely rare" = "4"
                   ),
                   selected = c("2")
                 )
          ),
          column(width = 6,
                 checkboxGroupInput(
                   inputId = ns("filter_region_fts"),
                   label = "Filter region",
                   choices = list(
                     "WP" = "wp",
                     "Central Europe" = "ce",
                     "southern Germany" = "sg",
                     "northern Germany" = "ng"
                   ),
                   selected = c("ce")
                 )
          )
        ),
        selectInput(
          inputId = ns("selected_species_fts"),
          label = "Choose species",
          choices = readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
            dplyr::filter(!is.na(deutscher.name)) %>%
            dplyr::select(deutscher.name) %>%
            dplyr::arrange(deutscher.name) %>%
            dplyr::rename(" " = 1),
          multiple = TRUE,
          selectize = TRUE
        ),
        # downloadButton(
        #   ns("download_json"),
        #   label = "Download 'Json' File"
        # )
      textInput(
        inputId = ns("folder_to_save_json"),
        label = "Folder to save Json file to",
        value = "/home/ralph/Downloads/test"#,
        #placeholder = 10
      ),
      #downloadButton("download", "Download JSON")
      div(actionButton(ns("export_jsonsamples"), "Download Json File", class = "btn-primary", icon = icon("angle-right")), style = "margin-top:25px"),
      )
    )
  )
}

#' jsonfilecreator Server Functions
#'
#' @noRd
mod_jsonfilecreator_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # filter detection list
    observe({
      updateSelectInput(session, "selected_species_dl",
                        choices =
                          readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
                          dplyr::filter(!is.na(deutscher.name)) %>%
                          dplyr::mutate(western_palearctic = as.numeric(western_palearctic)) %>%
                          dplyr::mutate(abundance = case_when("ce" %in% input$filter_region ~ middle_europe,
                                                              "wp" %in% input$filter_region ~ western_palearctic,
                                                              "sg" %in% input$filter_region ~ baden_wuerttemberg,
                                                              "ng" %in% input$filter_region ~ Norddeutschland)) %>%
                          dplyr::filter(abundance %in% input$filter_abundance) %>%
                          dplyr::select(deutscher.name) %>%
                          dplyr::arrange(deutscher.name) %>%
                          dplyr::rename(" " = 1)
                          )
    })

    # filter files to send list
    observe({
      updateSelectInput(session, "selected_species_fts",
                        choices =
                          readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
                              dplyr::filter(!is.na(deutscher.name)) %>%
                              dplyr::mutate(western_palearctic = as.numeric(western_palearctic)) %>%
                              dplyr::mutate(abundance = case_when("ce" %in% input$filter_region_fts ~ middle_europe,
                                                                  "wp" %in% input$filter_region_fts ~ western_palearctic,
                                                                  "sg" %in% input$filter_region_fts ~ baden_wuerttemberg,
                                                                  "ng" %in% input$filter_region_fts ~ Norddeutschland)) %>%
                              dplyr::filter(abundance %in% input$filter_abundance_fts) %>%
                              dplyr::select(deutscher.name) %>%
                              dplyr::arrange(deutscher.name) %>%
                              dplyr::rename(" " = 1)
      )
    })

    #export json file
    observeEvent(input$export_jsonsamples, {
      #browser()
      json_file <- list(
        monitoring = list(
          duration = input$mduration
        ),
        audio = list(
          device = input$device,
          format = input$format,
          duration = input$rduration,
          max_file_time = input$max_file_time,
          sample_rate = input$sample_rate,
          gain = input$gain,
          channels = input$channels,
          save_as_mono = input$save_as_mono,
          output_dir = input$output_dir,
          done_dir = input$done_dir,
          keep_audio = input$keep_audio,
          playback_file = input$playback_file,
          playback_count = input$playback_count
        ),
        birdnet = list(
          i = input$i,
          o = input$o,
          slist = input$slist,
          min_conf = input$min_conf,
          overlap = input$overlap,
          rtype = input$rtype,
          threads = input$threads
        ),
        species_of_interest = list(
          call_buffer = input$call_buffer,
          detections_dir = input$detections_dir,
          snippets_dir = input$snippets_dir,
          soi_list = readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
                        dplyr::filter(!is.na(deutscher.name)) %>%
                        dplyr::filter(deutscher.name %in% input$selected_species_fts) %>%
                        dplyr::select(birdnet_code)
        ),
        species_list = readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
          dplyr::filter(!is.na(deutscher.name)) %>%
          dplyr::filter(deutscher.name %in% input$selected_species_dl) %>%
          dplyr::select(birdnet_names)
       )
      writeLines(toJSON(json_file), paste0(input$folder_to_save_json, "/Settings_EcoPi.json"))
    })
  })
}

## To be copied in the UI
# mod_jsonfilecreator_ui("jsonfilecreator_1")

## To be copied in the server
# mod_jsonfilecreator_server("jsonfilecreator_1")
