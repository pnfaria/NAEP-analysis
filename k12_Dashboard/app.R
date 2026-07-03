library(shiny)
library(dplyr)
library(readr)
library(plotly)
library(DT)
library(tidyr)
library(janitor)


# =========================
# READ AND CLEAN DATA
# =========================

naep <- read_csv("data/naep.csv") |>
  clean_names() |>
  fill(year, .direction = "down") |>
  mutate(
    year = as.numeric(year),
    grade = as.numeric(grade),
    avg_scale_score = as.numeric(avg_scale_score)
  )

# =========================
# UI
# =========================

ui <- fluidPage(
  
  titlePanel("Dashboard – NAEP State Performance"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput(
        "year",
        "Year",
        choices = sort(unique(naep$year))
      ),
      
      selectInput(
        "grade",
        "Grade",
        choices = sort(unique(naep$grade))
      ),
      
      selectInput(
        "jurisdiction",
        "Jurisdiction",
        choices = sort(setdiff(unique(naep$jurisdiction), "National public"))
      ),
      
      downloadButton("download_csv", "Download CSV")
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel(
          "Overview",
          plotlyOutput("plot_difference"),
          plotlyOutput("plot_score")
        ),
        
        tabPanel(
          "Trend",
          plotlyOutput("plot_trend")
        ),
        
        tabPanel(
          "Table",
          DTOutput("table")
        ),
      )
    )
  )
)

# =========================
# SERVER
# =========================

server <- function(input, output, session) {
  
  dados_filtrados <- reactive({
    
    df <- naep |>
      filter(
        year == as.numeric(input$year),
        grade == as.numeric(input$grade)
      )
    
    national_score <- df |>
      filter(jurisdiction == "National public") |>
      pull(avg_scale_score)
    
    df |>
      mutate(
        diff_national = avg_scale_score - national_score
      )
  })
  
  observeEvent(list(input$year, input$grade), {
    
    df <- dados_filtrados() |>
      filter(jurisdiction != "National public")
    
    updateSelectInput(
      session,
      "jurisdiction",
      choices = sort(unique(df$jurisdiction)),
      selected = sort(unique(df$jurisdiction))[1]
    )
  })
  
  output$plot_difference <- renderPlotly({
    
    df <- dados_filtrados() |>
      filter(jurisdiction != "National public") |>
      arrange(diff_national)
    
    plot_ly(
      df,
      x = ~diff_national,
      y = ~reorder(jurisdiction, diff_national),
      type = "bar",
      orientation = "h"
    ) |>
      layout(
        title = "State Performance Compared with National Public Average",
        xaxis = list(title = "Difference from National Public"),
        yaxis = list(title = "")
      )
  })
  
  output$plot_score <- renderPlotly({
    
    df <- dados_filtrados() |>
      filter(jurisdiction != "National public") |>
      arrange(desc(avg_scale_score))
    
    plot_ly(
      df,
      x = ~reorder(jurisdiction, avg_scale_score),
      y = ~avg_scale_score,
      type = "bar"
    ) |>
      layout(
        title = "Average Scale Score by State",
        xaxis = list(title = "State"),
        yaxis = list(title = "Average Scale Score")
      )
  })
  
  output$plot_trend <- renderPlotly({
    
    df_state <- naep |>
      filter(
        jurisdiction == input$jurisdiction,
        grade == as.numeric(input$grade)
      ) |>
      arrange(year)
    
    df_national <- naep |>
      filter(
        jurisdiction == "National public",
        grade == as.numeric(input$grade)
      ) |>
      arrange(year)
    
    plot_ly() |>
      add_lines(
        data = df_state,
        x = ~year,
        y = ~avg_scale_score,
        name = input$jurisdiction,
        line = list(
          color = "#E69F00",
          width = 3)
      ) |>
      add_markers(
        data = df_state,
        x = ~year,
        y = ~avg_scale_score,
        name = input$jurisdiction,
        marker = list(
          color = "#56b4e9",
          size = 10,
          symbol = "circle"
        )
      ) |>
      add_lines(
        data = df_national,
        x = ~year,
        y = ~avg_scale_score,
        name = "National public",
        line = list(
          color = "#009E73",
          width = 3)
      ) |>
      add_markers(
        data = df_national,
        x = ~year,
        y = ~avg_scale_score,
        name = "National public",
        marker = list(
          color = "#CC79a7",
          size = 10,
          symbol = "circle"
        )
      ) |>
      layout(
        title = paste("Trend Compared with National Public -", input$jurisdiction),
        xaxis = list(title = "Year"),
        yaxis = list(title = "Average Scale Score")
      )
  })
  
  output$table <- renderDT({
    datatable(dados_filtrados())
  })
  
  output$download_csv <- downloadHandler(
    filename = function() {
      paste0("naep_", input$year, "_grade_", input$grade, ".csv")
    },
    content = function(file) {
      write_csv(dados_filtrados(), file)
    }
  )
}

# =========================
# RUN APP
# =========================

shinyApp(ui, server)