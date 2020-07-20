// Copyright CERN and copyright holders of ALICE O2. This software is
// distributed under the terms of the GNU General Public License v3 (GPL
// Version 3), copied verbatim in the file "COPYING".
//
// See http://alice-o2.web.cern.ch/license for full licensing information.
//
// In applying this license CERN does not waive the privileges and immunities
// granted to it by virtue of its status as an Intergovernmental Organization
// or submit itself to any jurisdiction.
#ifndef FRAMEWORK_FRAMEWORKGUIDEVICEGRAPH_H_
#define FRAMEWORK_FRAMEWORKGUIDEVICEGRAPH_H_

#if __has_include(<DebugGUI/DebugGUI.h>)

#include "../../src/DataProcessorInfo.h"
#include "Framework/DeviceSpec.h"
#include "Framework/DeviceInfo.h"
#include "Framework/DeviceMetricsInfo.h"

#include <vector>

namespace o2
{
namespace framework
{
namespace gui
{

class WorkspaceGUIState;

void showTopologyNodeGraph(WorkspaceGUIState& state,
                           std::vector<DeviceInfo> const& infos,
                           std::vector<DeviceSpec> const& specs,
                           std::vector<DataProcessorInfo> const& metadata,
                           std::vector<DeviceControl>& controls,
                           std::vector<DeviceMetricsInfo> const& metricsInfos);

} // namespace gui
} // namespace framework
} // namespace o2

#endif
#endif // FRAMEWORK_FRAMEWORKGUIDEVICEGRAPH_H_
