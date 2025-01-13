library(GeoLocatoR)
library(frictionless)

zenodo <- zen4R::ZenodoManager$new(token = keyring::key_get(service = "ZENODO_PAT"))

z <- zenodo$getDepositionByConceptDOI("10.5281/zenodo.14191023")

pkg <- zenodoRecord2gldp(z)

pkg <- add_gldp_geopressuretemplate(pkg)

validate_gldp(pkg)

# New version
pkg$version <- "v1.1.0"
z$setVersion(pkg$version)

# Write datapackage
write_package(pkg, pkg$version)

# Create new record
z <- zenodo$depositRecordVersion(
  z,
  delete_latest_files = TRUE,
  files = file.path(pkg$version, list.files(pkg$version)),
  publish = FALSE
)


# Upload on Zenodo
# https://zenodo.org/uploads/new
# Use the information in datapackage.json to fill the zenodo form.
