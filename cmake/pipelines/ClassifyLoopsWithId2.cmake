# cmake file

message(STATUS "setting up pipeline ClassifyLoopsWithId2")

find_package(ClassifyLoops CONFIG)

if(NOT ClassifyLoops_FOUND)
  message(WARNING "package ClassifyLoops was not found; skipping.")

  return()
endif()

get_target_property(SLE_LIB_LOCATION LLVMClassifyLoopsPass LOCATION)

# configuration

macro(ClassifyLoopsWithId2PipelineSetup)
  set(PIPELINE_NAME "ClassifyLoopsWithId2")
  set(PIPELINE_INSTALL_TARGET "${PIPELINE_NAME}-install")
endmacro()


function(ClassifyLoopsWithId2Pipeline trgt)
  ClassifyLoopsWithId2PipelineSetup()

  if(NOT TARGET ${PIPELINE_NAME})
    add_custom_target(${PIPELINE_NAME})
  endif()

  set(PIPELINE_SUBTARGET "${PIPELINE_NAME}_${trgt}")
  set(PIPELINE_PREFIX ${PIPELINE_SUBTARGET})

  set(DEPENDEE_TRGT "SimplifyLoopExitsFront_${trgt}_link")

  ## pipeline targets and chaining

  ## pipeline targets and chaining
  create_file_cmdline_arg(CMDLINE_OPTION "-classify-loops-iofuncs"
    FILENAME "$ENV{HARNESS_INPUT_DIR}${BMK_NAME}/PropagateAttributes-filtered-icsa-io.txt"
    CMDLINE_ARG PIPELINE_CMDLINE_ARG1)

  create_file_cmdline_arg(CMDLINE_OPTION "-classify-loops-iofuncs"
    FILENAME "$ENV{HARNESS_INPUT_DIR}${BMK_NAME}/PropagateAttributes-propagated-icsa-io.txt"
    CMDLINE_ARG PIPELINE_CMDLINE_ARG2)

  create_file_cmdline_arg(CMDLINE_OPTION "-classify-loops-nlefuncs"
    FILENAME "$ENV{HARNESS_INPUT_DIR}${BMK_NAME}/PropagateAttributes-filtered-noreturn.txt"
    CMDLINE_ARG PIPELINE_CMDLINE_ARG3)

  create_file_cmdline_arg(CMDLINE_OPTION "-classify-loops-nlefuncs"
    FILENAME "$ENV{HARNESS_INPUT_DIR}${BMK_NAME}/PropagateAttributes-propagated-noreturn.txt"
    CMDLINE_ARG PIPELINE_CMDLINE_ARG4)

  create_file_cmdline_arg(CMDLINE_OPTION "-classify-loops-fn-whitelist"
    FILENAME "$ENV{HARNESS_INPUT_DIR}${BMK_NAME}/cxx_user_functions.txt"
    CMDLINE_ARG PIPELINE_CMDLINE_ARG5)

  llvmir_attach_opt_pass_target(${PIPELINE_PREFIX}_link
    ${DEPENDEE_TRGT}
    -load ${SLE_LIB_LOCATION}
    -classify-loops
    ${PIPELINE_CMDLINE_ARG1}
    ${PIPELINE_CMDLINE_ARG2}
    ${PIPELINE_CMDLINE_ARG3}
    ${PIPELINE_CMDLINE_ARG4}
    ${PIPELINE_CMDLINE_ARG5}
    -classify-loops-stats=${HARNESS_REPORT_DIR}/${BMK_NAME}-${PIPELINE_NAME}.txt)
  add_dependencies(${PIPELINE_PREFIX}_link ${DEPENDEE_TRGT})

  llvmir_attach_executable(${PIPELINE_PREFIX}_bc_exe ${PIPELINE_PREFIX}_link)
  add_dependencies(${PIPELINE_PREFIX}_bc_exe ${PIPELINE_PREFIX}_link)

  target_link_libraries(${PIPELINE_PREFIX}_bc_exe m)

  ## pipeline aggregate targets
  add_custom_target(${PIPELINE_SUBTARGET} DEPENDS
    ${DEPENDEE_TRGT}
    ${PIPELINE_PREFIX}_link
    ${PIPELINE_PREFIX}_bc_exe)

  add_dependencies(${PIPELINE_NAME} ${PIPELINE_SUBTARGET})


  # installation
  get_property(bmk_name TARGET ${trgt} PROPERTY BMK_NAME)

  InstallClassifyLoopsWithId2PipelineLLVMIR(${PIPELINE_PREFIX}_link ${bmk_name})
endfunction()


function(InstallClassifyLoopsWithId2PipelineLLVMIR pipeline_part_trgt bmk_name)
  ClassifyLoopsWithId2PipelineSetup()

  if(NOT TARGET ${PIPELINE_INSTALL_TARGET})
    add_custom_target(${PIPELINE_INSTALL_TARGET})
  endif()

  get_property(llvmir_dir TARGET ${pipeline_part_trgt} PROPERTY LLVMIR_DIR)

  # strip trailing slashes
  string(REGEX REPLACE "(.*[^/]+)(//*)$" "\\1" llvmir_stripped_dir ${llvmir_dir})
  get_filename_component(llvmir_part_dir ${llvmir_stripped_dir} NAME)

  set(PIPELINE_DEST_SUBDIR
    ${CMAKE_INSTALL_PREFIX}/CPU2006/${bmk_name}/llvm-ir/${llvmir_part_dir})

  set(PIPELINE_PART_INSTALL_TARGET "${pipeline_part_trgt}-install")

  add_custom_target(${PIPELINE_PART_INSTALL_TARGET}
    COMMAND ${CMAKE_COMMAND} -E
    copy_directory ${llvmir_dir} ${PIPELINE_DEST_SUBDIR})

  add_dependencies(${PIPELINE_PART_INSTALL_TARGET} ${pipeline_part_trgt})
  add_dependencies(${PIPELINE_INSTALL_TARGET} ${PIPELINE_PART_INSTALL_TARGET})
endfunction()


