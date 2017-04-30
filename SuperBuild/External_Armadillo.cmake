# Add Armadillo
#
# Warning: CMake's FindArmadillo.cmake will always search in default CMake paths and cannot be
# forced to search first in an alternative location (e.g. via ARMADILLO_ROOT or so).
# Therefore future find_package statements might still find the system one even if you
# build your own.

#This needs to be unique globally
set(proj Armadillo)

# Set dependency list
set(${proj}_DEPENDENCIES "")

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} DEPENDS_VAR ${proj}_DEPENDENCIES)

# Set external name (same as internal for now)
set(externalProjName ${proj})

if(NOT ( DEFINED "USE_SYSTEM_${externalProjName}" AND "${USE_SYSTEM_${externalProjName}}" ) )
  message(STATUS "${__indent}Adding project ${proj}")

  ### --- Project specific additions here
  set(${proj}_Install_Dir ${CMAKE_CURRENT_BINARY_DIR}/INSTALL)

  set(${proj}_URL   https://downloads.sourceforge.net/project/arma/armadillo-7.800.2.tar.xz?r=http%3A%2F%2Farma.sourceforge.net%2Fdownload.html&ts=1492950217&use_mirror=freefr
 )
  set(${proj}_MD5 c601f3a5ec6d50666aa3a539fa20e6ca )

  # name after extraction
  set(${proj}_location Armadillo)

  if(CMAKE_COMPILER_IS_CLANGXX)
    set(CLANG_ARG -DCMAKE_COMPILER_IS_CLANGXX:BOOL=ON)
  endif()

  set(${proj}_SOURCE_DIR ${SOURCE_DOWNLOAD_CACHE}/${proj}-prefix/src/${${proj}_location} )

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    URL ${${proj}_URL}
    URL_HASH MD5=${${proj}_MD5}
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${proj}
    CONFIGURE_COMMAND ${CMAKE_COMMAND}
                             ${CLANG_ARG}
                             -DCMAKE_INSTALL_PREFIX:PATH=${${proj}_Install_Dir} "${${proj}_SOURCE_DIR}"

    #BUILD_COMMAND ${CMAKE_COMMAND}
    #                         -DBUILD_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/${proj}
    #                         -DINSTALL_DIR:PATH=${${proj}_Install_Dir}
    INSTALL_DIR ${${proj}_Install_Dir}
  )

  # no point doing this as FindArmadillo doesn't honour any *_ROOT or *_DIR settings
  #set( ARMADILLO_ROOT ${${proj}_Install_Dir} )
  set(ARMADILLO_INCLUDE_DIRS ${${proj}_Install_Dir}/include )
  # TODO: probably should set ARMADILLO_LIBRARIES
 else()
    if(${USE_SYSTEM_${externalProjName}})
      find_package(${proj} ${${externalProjName}_REQUIRED_VERSION} REQUIRED)
      message(STATUS "USING the system ${externalProjName}, found ARMADILLO_LIBRARIES=${ARMADILLO_LIBRARIES}}")
  endif()
  ExternalProject_Add_Empty(${proj} "${${proj}_DEPENDENCIES}")
endif()

mark_as_superbuild(
  VARS
    ${externalProjName}_DIR:PATH
  LABELS
    "FIND_PACKAGE"
)