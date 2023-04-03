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
      # Title panel for settings
      titlePanel("Settings"),

      # Box for Pi settings
      box(
        titlePanel("ecoPiBirdID - settings of the Pi"),
        textInput(ns("device"), "Audio device:", value = "hifiberry"), # Input field for audio device
        numericInput(ns("gain"), "Gain:", min = 5, max = 40, step = 1, value = "40"), # Numeric input for gain
        textInput(ns("output_dir"), "Recordings output directory:", value = "/home/pi/output/recordings/todo"), # Input field for recordings output directory
        textInput(ns("done_dir"), "Recordings done directory:", value = "/home/pi/output/recordings/done"), # Input field for recordings done directory
        checkboxInput(ns("keep_audio"), "Keep audio:", value = TRUE) # Checkbox for keeping audio
      ),

      # Box for Recording Settings
      box(
        titlePanel("ecoPiBirdID - settings of the recordings"),
        selectInput(inputId = ns("format"), "Audio format:", choices = c("wav", "flac"), selected = "wav"), # Select input for audio format
        numericInput(inputId = ns("mduration"), "Monitoring duration (seconds):", value = 1800), # Numeric input for monitoring duration
        numericInput(inputId = ns("rduration"), "Recording duration (seconds):", value = 1800), # Numeric input for recording duration
        numericInput(inputId = ns("max_file_time"), "Max file time (seconds):", value = 600), # Numeric input for max file time
        selectInput(inputId = ns("sample_rate"), "Sample rate:", choices = c(24000, 32000, 44100, 48000, 88000, 96000), selected = 48000), # Select input for sample rate
        selectInput(inputId = ns("channels"), "Number of channels:", choices = c(1,2), selected = 2), # Select input for number of channels
        checkboxInput(inputId = ns("save_as_mono"), "Save as mono:", value = TRUE) # Checkbox for saving as mono
      ),

      # Box for BirdNET Settings
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
      # Box for ecoPiBoom Settings
        box(
          titlePanel("ecoPiBoom"),
          textInput(ns("playback_file"), "Playback file:", value = "playback/Flussseeschwalbe_stereo_1min35s.flac"),
          numericInput(ns("playback_count"), "Playback count:", min = 0, value = 0)
        )
      ),
    # list of species, which should be detected by BirdNET
    fluidRow(
      column(
        width = 6,
        titlePanel("Species List - detection list"),
        # filter for abundance
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
          # filter for region
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
        # set the list of species, which should be detected by BirdNET
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
        # list of species, of which the files should be send
        titlePanel("Species List - Files to send"),
        # filter for abundance
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
                   selected = c("1", "2")
                 )
          ),
          #filter for region
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
        # set the list of species, of which the files should be send
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
      # set the folder to save the json file to
      textInput(
        inputId = ns("folder_to_save_json"),
        label = "Folder to save Json file to",
        value = "/home/ralph/Downloads/test"
      ),
      div(actionButton(ns("export_jsonsamples"), "Download Json File", class = "btn-primary", icon = icon("angle-right")), style = "margin-top:25px"), # button to download the json-file
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

    # filter the list of species, which should be detected by BirdNET
    observe({
      updateSelectInput(session, "selected_species_dl",
                        choices =
                          readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
                          dplyr::filter(!is.na(deutscher.name)) %>%
                          dplyr::mutate(abundance = case_when("ce" %in% input$filter_region ~ middle_europe, # filter for region
                                                              "wp" %in% input$filter_region ~ western_palearctic,
                                                              "sg" %in% input$filter_region ~ baden_wuerttemberg,
                                                              "ng" %in% input$filter_region ~ Norddeutschland)) %>%
                          dplyr::filter(abundance %in% input$filter_abundance) %>% # filter for abundance
                          dplyr::select(deutscher.name) %>%
                          dplyr::arrange(deutscher.name) %>%
                          dplyr::rename(" " = 1)
                          )
    })

    # filter the list of species, which files should be send
    observe({
      updateSelectInput(session, "selected_species_fts",
                        choices =
                          readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>%
                              dplyr::filter(!is.na(deutscher.name)) %>%
                              dplyr::mutate(abundance = case_when("ce" %in% input$filter_region_fts ~ middle_europe, # filter for region
                                                                  "wp" %in% input$filter_region_fts ~ western_palearctic,
                                                                  "sg" %in% input$filter_region_fts ~ baden_wuerttemberg,
                                                                  "ng" %in% input$filter_region_fts ~ Norddeutschland)) %>%
                              dplyr::filter(abundance %in% input$filter_abundance_fts) %>% #filter for abundance
                              dplyr::select(deutscher.name) %>%
                              dplyr::arrange(deutscher.name) %>%
                              dplyr::rename(" " = 1)
      )
    })

    #export json file
    observeEvent(input$export_jsonsamples, { # Triggered by a user action
      #browser() # Debugging line. Should be removed in the final version
      list_species_files_to_send = # Getting a list of species codes
        readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>% # Read an Excel file
        dplyr::filter(!is.na(deutscher.name)) %>% # Filtering out NA values in the column 'deutscher.name'
        dplyr::filter(deutscher.name %in% input$selected_species_fts) %>% # Filtering based on user input
        dplyr::select(birdnet_code) %>% # Selecting the 'birdnet_code' column
        unlist(.) %>% # Converting the data frame to a vector
        as.character(.) # Converting the vector elements to characters

      list_species_detection = # Getting a list of species names
        readxl::read_xlsx(path = "/home/ralph/Dokumente/BirdNET_species_selection/species_list.xlsx", col_names = TRUE) %>% # Read an Excel file
        dplyr::filter(!is.na(deutscher.name)) %>% # Filtering out NA values in the column 'deutscher.name'
        dplyr::filter(deutscher.name %in% input$selected_species_dl) %>% # Filtering based on user input
        dplyr::select(birdnet_names) %>% # Selecting the 'birdnet_names' column
        unlist(.) %>% # Converting the data frame to a vector
        as.character(.) # Converting the vector elements to characters

      json_file <- list( # Creating a list to export as JSON file
        monitoring = list(
          duration = input$mduration # Getting user input
        ),
        audio = list(
          device = input$device, # Getting user input
          format = input$format, # Getting user input
          duration = input$rduration, # Getting user input
          max_file_time = input$max_file_time, # Getting user input
          sample_rate = as.numeric(input$sample_rate), # Getting user input and converting to numeric
          gain = as.character(input$gain), # Getting user input and converting to character
          channels = as.numeric(input$channels), # Getting user input and converting to numeric
          save_as_mono = input$save_as_mono, # Getting user input
          output_dir = input$output_dir, # Getting user input
          done_dir = input$done_dir, # Getting user input
          keep_audio = input$keep_audio, # Getting user input
          playback_file = input$playback_file, # Getting user input
          playback_count = input$playback_count # Getting user input
        ),
        birdnet = list(
          i = input$i, # Getting user input
          o = input$o, # Getting user input
          slist = input$slist, # Getting user input
          min_conf = input$min_conf, # Getting user input
          overlap = input$overlap, # Getting user input
          rtype = input$rtype, # Getting user input
          threads = input$threads # Getting user input
        ),

        species_of_interest = list(
          call_buffer = input$call_buffer, # Getting user input
          detections_dir = input$detections_dir, # Getting user input
          snippets_dir = input$snippets_dir, # Getting user input
          soi_list = list_species_files_to_send # list of species, which the Pi should send
        ),
        species_list = list_species_detection # list of species, which should get be exported by BirdNET
      )

      writeLines(toJSON(json_file, # Converting the created list to JSON format
                        auto_unbox = TRUE), # Unboxing nested lists
                 paste0(input$folder_to_save_json, "/1_Settings_EcoPi.json")) # Saving the JSON file in the specified folder
    })
  })
}

## To be copied in the UI
# mod_jsonfilecreator_ui("jsonfilecreator_1")

## To be copied in the server
# mod_jsonfilecreator_server("jsonfilecreator_1")
