#- HOME TAB 
about <- tabItem(
  tabName = "about",
  
  fluidPage(
    column(
      width = 12,
      # class = 'home_welcome',
      HTML('<h2>Bienvenido a <b>Pet Match</b> system </h2>') %>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "Cómo navegar en Pet Match:",
          content = c(
            "En la pestaña del lado izquierdo hay 3 opciones: Acerca de Pet Match, Encuentra tu mascota y Análisis (si estas tres opciones no están visibles, haz clic en el icono con 3 líneas horizontales a la izquierda).",
            "",
            "En Acerca de Pet Match, encontrarás información sobre el proyecto y cómo surgió esta idea.",
            "En Encuentra tu mascota, encontrarás un formulario a rellenar para que podamos encontrar la mascota que mejor se adapta a ti.",
            "En Análisis, encuentrarás un análisis exploratorio de las características de los animales en adopción que tenemos en nuestra base de datos.",
            ""
          ),
          buttonLabel = 'OK!'),
      HTML('<h3> <b>Pet mach</b> es una herramienta creada con el objetivo de aumentar el número de animales adoptados, a través de un sistema de recomendación según el perfil del usuario.</h3>'),
      h4("Según un estudio realizado por Veterindustria y Asociación Nacional de Fabricantes de Alimentos para Animales de Compañía (ANFAAC), en 2021 hubo un aumento significativo del 39,7% de personas que tienen una mascota en comparación con 2019. Según las protectoras de animales españolas, el 51% de perros y gatos que estaban disponibles para adopción en 2021 han sido adoptados, pero todavía hay un gran porcentaje de animales en adopción y animales abandonados."),
      h4("Con las iniciativas de las comunidades en España para construir un entorno tecnológico para la consulta pública de datos a través de APIs, cada vez se difunden más datos interesantes para ser analizados, y esto incluye a las mascotas. A día de hoy, la comunidad de Zaragoza ya dispone de una API pública que facilita el acceso a esta información."),
      h4("Sin embargo, con información más accesible, surge otra pregunta, cómo elegir una mascota para adopción. Muchas personas quieren tener un animal de compañía pero no son conscientes de las necesidades del animal y que pueden no se ajustar a su estilo de vida, como, por ejemplo, el tiempo disponible para interactuar con la mascota (menos horas tal vez significa que un cachorro no es para ti y tal vez un animal adulto es mejor compañía) o el espacio disponible (si vives en un departamento no será posible adoptar una mascota grande, quizás la opción aquí sea un gato o un perro pequeño).
"),
      HTML('<h4> Surge así el <b>PET MATCH</b> con la oportunidad de analizar estos datos de APIs públicas sobre mascotas en adopción y crear un entorno tecnológico que permita unir al interesado en adoptar con la mascota que se adapta a su estilo de vida, y así intentar reducir el problema de animales abandonados.</h4>'),
      br(),
      hr()
    )
    
  )
  
  
)
