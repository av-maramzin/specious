# cmake file

set(BMK_NAME "471.omnetpp")
set(PROJECT_NAME "omnetpp")

set(SOURCES
  EtherAppCli.cc
  EtherAppCli_n.cc
  EtherAppSrv.cc
  EtherAppSrv_n.cc
  EtherApp_m.cc
  EtherBus.cc
  EtherBus_n.cc
  EtherCtrl_m.cc
  EtherEncap.cc
  EtherEncap_n.cc
  EtherFrame_m.cc
  EtherHost_n.cc
  EtherHub.cc
  EtherHub_n.cc
  EtherLLC.cc
  EtherLLC_n.cc
  EtherMAC.cc
  EtherMAC_n.cc
  EtherSwitch_n.cc
  LargeNet_n.cc
  MACAddress.cc
  MACAddress_m.cc
  MACRelayUnitBase.cc
  MACRelayUnitNP.cc
  MACRelayUnitNP_n.cc
  MACRelayUnitPP.cc
  MACRelayUnitPP_n.cc
  MACRelayUnit_n.cc
  Networks_n.cc
  eth-index_n.cc
  utils.cc
  libs/cmdenv/cmdenv.cc
  libs/cmdenv/enumstr.cc
  libs/cmdenv/heap.cc
  libs/envir/akoutvectormgr.cc
  libs/envir/args.cc
  libs/envir/cenvir.cc
  libs/envir/cinifile.cc
  libs/envir/filemgrs.cc
  libs/envir/main.cc
  libs/envir/omnetapp.cc
  libs/envir/patmatch.cc
  libs/envir/platdep.cc
  libs/envir/seeds.cc
  libs/envir/slaveapp.cc
  libs/envir/speedmtr.cc
  libs/sim/carray.cc
  libs/sim/cexception.cc
  libs/sim/cmessage.cc
  libs/sim/cpar.cc
  libs/sim/ctypes.cc
  libs/sim/task.cc
  libs/sim/cchannel.cc
  libs/sim/cfsm.cc
  libs/sim/cmodule.cc
  libs/sim/cpsquare.cc
  libs/sim/cvarhist.cc
  libs/sim/util.cc
  libs/sim/ccoroutine.cc
  libs/sim/cgate.cc
  libs/sim/cmsgheap.cc
  libs/sim/cqueue.cc
  libs/sim/cwatch.cc
  libs/sim/cdensity.cc
  libs/sim/chead.cc
  libs/sim/cnetmod.cc
  libs/sim/csimul.cc
  libs/sim/distrib.cc
  libs/sim/cdetect.cc
  libs/sim/chist.cc
  libs/sim/cobject.cc
  libs/sim/cstat.cc
  libs/sim/errmsg.cc
  libs/sim/cdispstr.cc
  libs/sim/cksplit.cc
  libs/sim/coutvect.cc
  libs/sim/cstruct.cc
  libs/sim/onstartup.cc
  libs/sim/cenum.cc
  libs/sim/cllist.cc
  libs/sim/cpacket.cc
  libs/sim/ctopo.cc
  libs/sim/random.cc 
  libs/sim/std/netpack.cc
  libs/spec/spec_qsort.cc)

add_prefix(SOURCES "${BENCHMARK_SOURCE_DIR}/" "${SOURCES}")

add_executable(${PROJECT_NAME} ${SOURCES})

# this property is required by our parasitic targets
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)

target_include_directories(${PROJECT_NAME} PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/${BENCHMARK_SOURCE_DIR}")
target_include_directories(${PROJECT_NAME} PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/${BENCHMARK_SOURCE_DIR}/omnet_include/")
target_include_directories(${PROJECT_NAME} PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/${BENCHMARK_SOURCE_DIR}/libs/sim/")
target_include_directories(${PROJECT_NAME} PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/${BENCHMARK_SOURCE_DIR}/libs/cmdenv/")
target_include_directories(${PROJECT_NAME} PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/${BENCHMARK_SOURCE_DIR}/libs/envir/")

target_link_libraries(${PROJECT_NAME} m)


include_fragments("${PROJECT_CMAKE_FRAGMENT_FILES}")
