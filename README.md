# Práctica iOS1 - Hackerbooks

## Modelo

Para la parte del modelo, se han creado las siguientes clases:

**AGTBook:** Esta clase contiene la información que va a contener un libro, esto es: título, autores, tags, las URL a las imágenes y a los PDF y si un libro está marcado o no como favorito.      

A su vez, va a contener dos inicializadores designados: uno en el que se le pasan todas las propiedades y otro que va a ir a local, recogiendo cada una de las propiedades del objeto e inicializando cada una de ellas.      

Por último, implementa los protocolos de *NSCoding* (para inicializar un objeto de local usando Archiving) y *Comparable* para poder posteriormente ordenar estos objetos.   

**AGTLibrary:** Esta clase contiene la información relativa a la biblioteca. Para ello mantiene 3 arrays diferentes:      
*books:* Este array contiene objetos de tipo AGTBook con la información de los libros, bien recogda de local o bien decodificada de un JSON.   
*tags:* Este array va a contener todos los tags (no repetidos) que se encuentren dentro del array *books*.    
*favorites:* Este array de enteros, contiene los índices, del array books que se han marcado como favoritos.  

Contiene dos inicializadores designados distintos, dependiendo de si la inicialización se realiza a partir de un JSON o bien se usa un objeto en local con la información almacenada.    

Dentro de los inicializadores, se calculan los tags no repetidos del array *books* y se ordenan ambos arrays (usando el método sort de cada uno de ellos). Por último también se obtienen todos aquellos libros marcados como favoritos.  

Esta clase también contiene los siguientes métodos:    
*booksForTag:* Método al que se le pasa un tag (en forma de cadena) y retorna una tupla que indica la cantidad de libros encontrados para el tag y un array que indica cuales son estos libros.  
*bookAtIndex:* Método al que se le pasa un índice (entero) y un tag(en forma de cadena) y retorna un objeto de tipo AGTBook que es el libro que ocupa el índice indicado para el tag especificado.    

Además de las clases anteriores, se han creado los siguientes ficheros:    

**JSONProcessing:** Este fichero contiene las funciones necesarias para la decodificación de un JSON y la creación de un objeto AGTBook.  
También contiene una función que almacena las imágenes en local, bajo una carpeta /Document/images dentro del sandbox de la aplicación y modifica la infromación de la URL para un AGTBook indicando que se trata de una path en local.  
Se ha obtado por no hacer lo mismo con los PDF (aunque el proceso sería idéntico al de las imágenes) ya que bloqueaba durante demasiado tiempo la primera ejecución de la aplicación. De esta forma cada vez que se realice una peticicón del PDF, este se desacargará de la URL remota.    

**Functions:** Este fichero contiene las funciones para obtener los tags y los favoritos del array books de la clase AGTLibrary y una función para leer una imagen de /Documents/images a partir del nombre de la misma.    

Se ha obtado por almacenar la información de array books usando la técnica de archiving en un fichero llamado /books.archive dentro del sandbox de la aplicación ya que, una vez que se ha decodificado la información, es un proceso sencillo y rápido debido a que muchos de los objetos usados, como por ejemplo Strings, ya implementan el protocolo NSCoding y saben como tienen que guardarse en local y obtenerse posterioremnte. Además de esta forma se puede almacenar y recuperar posteriormente la marca de si un libro es o no favorito de forma muy sencilla.
Otra opción podría haber sido almacenar el JSON que se pasa como parámetro directaemtente e ir decodificándolo cada vez, pero aquí habría que haber usado otra alternativa para persistir la información de que un libro es favorito.    

## Controladores

Para hacer la aplicación universal se ha usado un SplitViewController. Dentro de este se ha usado un NavigationController junto con un TableViewController llamado MasterViewController.    

**MasterViewController:** Este controlador se encarga del Table View de la aplicación. La forma de funcionar es la siguiente: Cuando se acaba de cargar, comprueba si es la primera vez que se ejecuta la aplicación (a través de la propiedad "firstTime").    

Si es la primera vez que se ejecuta, escribe dentro de la propiedad "firstTime" el valor "YES", obtiene de la URL indicada el fichero JSON, lo decodifica, crea el modelo y guarda los cambios en local. Si no es la primera vez que se ejecuta la App, directamente crea el modelo a partir del fichero generado en local previamente.    

Este controlador también se encarga de ser el delegado del TableView y de contestar a las preguntas que le haga. Tambien implementa lo siguiente:  
*updateLibrary:* Se trata de una función que guarda cambios en local, recarga el array de favoritos y recarga el TableView. Se usa cuando en un libro se marca su opción de favoritos para refrescar la infromación que se ve en pantalla y que está almacenada. El uso de reloadData para recargar la tabla no supone penalización en rendimiento debido a que el volumen de información a recargar es bajo.  
*BookSelectionDelegate:* Se trata de un protocolo que implementará posteriormente la vista de detalle, en el que se pasará la información del modelo y el libro seleccionado para que pueda mostrar su información por pantalla y guardar cambios.    

**DetailViewCOntroller:** Este controlador, que se encuentra encapsulado dentro de un NavigationController, muestra el detalle de un objeto de tipo AGTBook que se haya seleccioando del TableView gestionado por MasterViewController.    

Cosas a destacar de este controlador, es que envía una notificación (gestionada por favoriteSwitchChangeKey) para indicar que ha cambiado el estado de favorito de un libro y que, cuando se ha cargado, comprueba el último libro que se seleccionó para, de esta forma poder mostrarlo.    

También usa la función prepareForSegue para pasar al controlador AGTSimplePDFViewController el libro, para poder mostrar su contenido (en forma de PDF).    

**AGTSimplePDFViewController:**  Este controlador se encarga de hace una petición para recaoger el PDF de la URL almacenada en el objeto AGTBook y mostrarlo dentro de un UIWebView. 





