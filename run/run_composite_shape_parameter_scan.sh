#!/usr/bin/env bash

set -u

# Run from the directory containing the kinematics files, or set KINEMATICS_DIR.
KINEMATICS_DIR=${KINEMATICS_DIR:-.}
LOG_DIR=${LOG_DIR:-composite_shape_scan_logs}
EVENTS=${EVENTS:-1000}
SEED=${SEED:-234567}

#kinematics_files=(
#  o2sim_Kine_pythia8pp.root
#  o2sim_Kine_pythia8pp_2.root
#  o2sim_Kine_pythia8pp_3.root
#  o2sim_Kine_pythia8pp_4.root
#  o2sim_Kine_pythia8pp_5.root
#)

kinematics_files=(
  o2sim_Kine_pythia8pp_3.root
  o2sim_Kine_pythia8pp_4.root
  o2sim_Kine_pythia8pp_5.root
)

configuration_names=(
  disabled
  min3_multidiff_inherit
  min6_multidiff_inherit
  min6_multidiff3
  min10_multidiff_inherit
  min10_multidiff3
)

geometry_manager_params=(
  "GeometryManagerParam.optimizeCompositeShapes=false"
  "GeometryManagerParam.optimizeCompositeShapes=true;GeometryManagerParam.compositeShapeMinimumLeaves=3;GeometryManagerParam.multiDifferenceMinimumLeaves=-1"
  "GeometryManagerParam.optimizeCompositeShapes=true;GeometryManagerParam.compositeShapeMinimumLeaves=6;GeometryManagerParam.multiDifferenceMinimumLeaves=-1"
  "GeometryManagerParam.optimizeCompositeShapes=true;GeometryManagerParam.compositeShapeMinimumLeaves=6;GeometryManagerParam.multiDifferenceMinimumLeaves=3"
  "GeometryManagerParam.optimizeCompositeShapes=true;GeometryManagerParam.compositeShapeMinimumLeaves=10;GeometryManagerParam.multiDifferenceMinimumLeaves=-1"
  "GeometryManagerParam.optimizeCompositeShapes=true;GeometryManagerParam.compositeShapeMinimumLeaves=10;GeometryManagerParam.multiDifferenceMinimumLeaves=3"
)

if ! command -v o2-sim-serial >/dev/null 2>&1; then
  echo "Error: o2-sim-serial is not available in PATH. Load the O2 environment first." >&2
  exit 1
fi

missing_inputs=0
for filename in "${kinematics_files[@]}"; do
  if [[ ! -f "${KINEMATICS_DIR}/${filename}" ]]; then
    echo "Error: missing kinematics file: ${KINEMATICS_DIR}/${filename}" >&2
    missing_inputs=1
  fi
done
if ((missing_inputs)); then
  exit 1
fi

mkdir -p "${LOG_DIR}"

failures=0
for filename in "${kinematics_files[@]}"; do
  kinematics_path="${KINEMATICS_DIR}/${filename}"
  kinematics_name=${filename%.root}

  for index in "${!geometry_manager_params[@]}"; do
    configuration_name=${configuration_names[index]}
    geometry_manager_param=${geometry_manager_params[index]}
    config_key_values="align-geom.mDetectors=none;${geometry_manager_param}"
    log_file="${LOG_DIR}/${kinematics_name}__${configuration_name}.log"

    echo "Running ${filename} with configuration ${configuration_name}"
    echo "Log: ${log_file}"

    simulation_command=(
      o2-sim-serial
      -n "${EVENTS}"
      -g extkinO2
      --extKinFile "${kinematics_path}"
      --configKeyValues "${config_key_values}"
      --skipModules ZDC
      -e TGeant4
      --seed "${SEED}"
    )

    #printf 'Command:'
    #printf ' %q' "${simulation_command[@]}"
    #printf ' >%q 2>&1\n' "${log_file}"

    if "${simulation_command[@]}" >"${log_file}" 2>&1; then
      echo "Completed ${filename} with configuration ${configuration_name}"
    else
      status=$?
      echo "FAILED ${filename} with configuration ${configuration_name} (exit code ${status})" >&2
      failures=$((failures + 1))
    fi
  done
done

if ((failures)); then
  echo "Completed parameter scan with ${failures} failed run(s)." >&2
  exit 1
fi

echo "Completed all ${#kinematics_files[@]} x ${#geometry_manager_params[@]} simulation runs successfully."
