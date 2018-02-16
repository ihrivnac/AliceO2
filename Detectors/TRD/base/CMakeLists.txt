SET(MODULE_NAME TRDBase)
SET(MODULE_NAMESPACE_NAME trd)

O2_SETUP(NAME ${MODULE_NAME})

SET(SRCS
  src/impl1/TRDPadPlane.cxx
  src/impl2/TRDPadPlane.cxx
  src/TRDGeometry.cxx
  src/TRDCommonParam.cxx
  src/TRDSimParam.cxx
)

SET(HEADERS
  include/trd/impl1/TRDPadPlane.h
  include/trd/impl2/TRDPadPlane.h
  include/trd/TRDGeometry.h
  include/trd/TRDSimParam.h
  include/trd/TRDCommonParam.h
)

SET(LINKDEF src/TRDBaseLinkDef.h)
SET(LIBRARY_NAME ${MODULE_NAME})
SET(BUCKET_NAME trd_base_bucket)

O2_GENERATE_LIBRARY()
