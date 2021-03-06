#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
DOWNLOAD_LINK="http://dirbaio.net/newer/Another_Super_Mario_Brothers_Wii_2.0.zip"
SOUNDTRACK_LINK="http://dirbaio.net/newer/Another_Super_Mario_Bros_Wii_Soundtrack.zip"
SOUNDTRACK_ZIP="Another_Super_Mario_Bros_Wii_Soundtrack.zip"
RIIVOLUTION_ZIP="Another_Super_Mario_Brothers_Wii_2.0.zip"
RIIVOLUTION_DIR="Another"
GAMENAME="Another Super Mario Brothers Wii 2.0"
XML_SOURCE="${RIIVOLUTION_DIR}"
XML_FILE="Riivolution/Another.xml"
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr
WBFS_MASK="SMN[PEJ]01"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Another Super Mario Bros. Wii is a simple mod created by Skawo and
released in December 2010 which includes a full set of new levels with
the same themes as the original game.

Source:			http://www.newerteam.com/specials.html
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, USAv1, USAv2
************************************************"

}

detect_game_version () {


	nsmbw_version

	GAMEID=SMN${REG_LETTER}05
	CUSTOM_BANNER=http://dl.dropboxusercontent.com/u/101209384/${GAMEID}.bnr

	if [[ ${VERSION} == "EURv2" || ${VERSION} == "JPNv*" ]]; then
		echo -e "Version ${VERSION} is not supported!"
		exit 1
	fi

}

place_files () {

	NEW_DIRS=( "${WORKDIR}"/files/AnotherRes "${WORKDIR}"/files/Sample "${WORKDIR}"/files/EU/NedEU/staffroll "${WORKDIR}"/files/EU/NedEU/Message "${WORKDIR}"/files/EU/NedEU/Font )
	for dir in "${NEW_DIRS[@]}"; do
		mkdir -p "${dir}"
	done

	case ${VERSION} in
		EURv* )

			cp "${RIIVOLUTION_DIR}"/Lang/EUENGLISH.arc "${WORKDIR}"/files/EU/EngEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUENGLISH.arc "${WORKDIR}"/files/EU/NedEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUFRENCH.arc "${WORKDIR}"/files/EU/FraEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUGERMAN.arc "${WORKDIR}"/files/EU/GerEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUITALIAN.arc "${WORKDIR}"/files/EU/ItaEU/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/EUSPANISH.arc "${WORKDIR}"/files/EU/SpaEU/Message/Message.arc

			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/Lang/staffroll.bin "${WORKDIR}"/files/EU/"${dir}"/staffroll/
				cp "${RIIVOLUTION_DIR}"/Lang/mj2d00_PictureFont_32_RGBA8.brfnt "${WORKDIR}"/files/EU/"${dir}"/Font/
			done
			cp "${RIIVOLUTION_DIR}"/Layout/OpeningP/* "${WORKDIR}"/files/EU/Layout/openingTitle/

		;;

		USAv* )

			cp "${RIIVOLUTION_DIR}"/Lang/USENGLISH.arc "${WORKDIR}"/files/US/EngUS/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/USFRENCH.arc "${WORKDIR}"/files/US/FraUS/Message/Message.arc
			cp "${RIIVOLUTION_DIR}"/Lang/USSPANISH.arc "${WORKDIR}"/files/US/SpaUS/Message/Message.arc

			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in "${LANGDIRS[@]}"; do
				cp "${RIIVOLUTION_DIR}"/Lang/staffroll.bin "${WORKDIR}"/files/US/"${dir}"/staffroll/
				cp "${RIIVOLUTION_DIR}"/Lang/mj2d00_PictureFont_32_RGBA8.brfnt "${WORKDIR}"/files/US/"${dir}"/Font/
			done
			cp "${RIIVOLUTION_DIR}"/Layout/OpeningE/* "${WORKDIR}"/files/US/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Lang/Other/01-0{1,2,4,6}_N_1.bin "${WORKDIR}"/files/Replay/otehon/
	cp "${RIIVOLUTION_DIR}"/Stage/*.arc "${WORKDIR}"/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brstm "${WORKDIR}"/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Sound/*.brsar "${WORKDIR}"/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Layout/controllerInformation.arc "${WORKDIR}"/files/Layout/controllerInformation/
	cp "${RIIVOLUTION_DIR}"/Layout/MultiCorseSelectTexture.arc "${WORKDIR}"/files/Layout/textures/
	cp "${RIIVOLUTION_DIR}"/Object/*.arc "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/WorldMap/* "${WORKDIR}"/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/AnotherRes/* "${WORKDIR}"/files/AnotherRes/
	cp "${RIIVOLUTION_DIR}"/Object/Background/* "${WORKDIR}"/files/Object/
	cp "${RIIVOLUTION_DIR}"/Stage/Texture/* "${WORKDIR}"/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Sample/tobira.bti "${WORKDIR}"/files/Sample/

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" xml="${PATCHIMAGE_PATCH_DIR}/AnotherSMB-Loader.xml" -q
	${WIT} dolpatch ${DOL} xml="${PATCHIMAGE_PATCH_DIR}/NSMBW_AP.xml" -q

}
