## Carga el directorio proyecto
local FPC=$HOME/.proyect_control
if [[ -f $FPC/path_folder ]]; then

	## contiene el directorio del proyecto
	export prod=$(cat $FPC/path_folder)

fi

pro () {

	if [[ $1 == "this" ]]; then
		local actionstatus=true
		pwd > $FPC/path_folder || local actionstatus=false

		if [[ $actionstatus == true ]]; then
			echo "Ha sido fijada la carpeta de proyectos."
			echo "Reinicie el terminal, para actualizar los cambios."
		else
			echo "No se ha podido fijar la carpeta de proyectos."
		fi
	fi

	if [[ $1 == "init" ]]; then
		mkdir $FPC 2> /dev/null > /dev/null &&
		echo "Se ha creado correctamente el directorio de control de proyectos" ||
		echo "No se ha podido crear el directorio de control."
		echo "Puede que ya exista el directorio [$FPC]"
	fi

	if [[ $1 == "import" ]]; then
		## Ruta del directorio actual
		local pimport=$(pwd)
		## Nombre del directorio
		local nimport=$(basename $pimport)
		## Define el nombre del proyecto nuevo
		local noutput=""
		## Define la ruta del proyecto nuevo
		local poutput=""

		echo "[$pimport] $nimport"

		if [[ $prod == "" ]]; then
			echo "Debe definir el directorio de proyectos, para poder importar un proyecto.";
		else
			if [[ $2 == "" ]]; then
				if [[ -d $prod/$nimport ]]; then
					echo "Ya existe un proyecto con este nombre, no se puede importar el proyecto."
				else
					noutput="$nimport"
				fi
			else
				if [[ -d $prod/$2 ]]; then
					echo "Ya existe un proyecto con este nombre, no se puede importar el proyecto."
				else
					noutput="$2"
				fi
			fi

			if [[ $noutput != "" ]]; then
				poutput="$prod/$noutput"

				## proceso de captura del proyecto
				cd .. &&
				cp -r $pimport $poutput &&
				rm -rf $pimport &&
				ln -s $poutput $pimport &&
				cd $pimport &&
				echo "Se ha importado correctamente el proyecto $nimport a $poutput. y se ha creado un enlace simbólico a $pimport" ||
				echo "Ha ocurrido un error al importar el archivo."

			fi

		fi
	fi

	if [[ $1 = "" ]]; then
		echo -e "Usar: [cd] prod[\<Proyecto>]"
		echo -e "\tPermite mover al directorio de proyectos."
		echo
		echo -e "Las opciones a utilizar son:"
		echo -e "\t<Proyecto>\tSi se define el nombre del proyecto, se dirigirá hacia\n\t\t\tsu directorio."
		echo
		echo -e "Usar: pro <option> [<args>]"
		echo
		echo -e "Las opciones a utilizar son:"
		echo -e "\tinit\tInicia liza el directorio de \"Control de proyecto\"."
		echo -e "\tthis\tDefine el directorio actual como ruta de los proyectos."
		echo -e "\timport\tImporta la el proyecto actual a la ruta de los proyectos."
		echo -e "\thelp\tMuestra esto y su especificaciones de cada opción."
		echo
		echo -e "see: pro help <option>"
	fi

	if [[ $1 = "help" ]]; then
		if [[ $2 = "init" ]]; then
			echo -e "Usar: pro init"
			echo
			echo -e "\tInicialisa el directorio de control de proyectos ubicado en $FPC."
			echo
		fi
		if [[ $2 = "this" ]]; then
			echo -e "Usar: pro this"
			echo
			echo -e "\tDefine el directorio actual como directorio de proyectos."
			echo
		fi
		if [[ $2 = "import" ]]; then
			echo -e "Usar: pro import [<Nombre del proyecto>]"
			echo
			echo -e "\tImporta el directorio actual como un proyecto hacia el directorio de proyectos y luego crea un enlace simbólico remplazando al directorio actual."
			echo
			echo -e "\t<Nombre del proyecto>\tDefine el nuevo nombre al proyecto."
			echo
		fi
		if [[ $2 = "help" ]]; then
			echo -e "Usar: pro help <opción>"
			echo
			echo -e "\ŧPantalla de ayuda detalla la opción definida."
			echo
			echo -e "\t<opción>\tDefine la opción que se desea mostrar."
			echo
		fi
		if [[ $2 = "" ]]; then
			pro
		fi
	fi

}


