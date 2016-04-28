---
layout: wiki
title: Repair Framework
description: Explains how to set-up the repair framework for custom vehicles
group: framework
order: 5
parent: wiki
---

## 1. Pre-requisites

<div class="panel callout">
    <h5>Note:</h5>
    <p>You need to be able to edit the selections on the model or have the names of the selections before pursuing your reading.</p>
</div>

To obtain the selection names do the following:

`(getAllHitPointsDamage cursorObject) select 1;`

while pointing at the vehicle or read them directly from the P3D.

### 1.1 Model changes

<div class="panel callout">
    <h5>Note:</h5>
    <p>If this step is done properly you won't have to do much config wise.</p>
</div>

Make sure that the selections are done properly, this is the most important step, and probably the one that will make you gain the most time on the whole process.

## 2. Config values

```cpp
class CfgVehicles {
    class yourVehicleBaseClass {

        // Group hitpoints together and will repair them all at the same time
        ace_repair_hitpointGroups = { {"HitEngine", {"HitEngine1", "HitEngine2"}}, {"Glass_1_hitpoint", {"Glass_2_hitpoint", "Glass_3_hitpoint", "Glass_4_hitpoint"}} };

        // Modify the position of a hitpoint, needed in case you didn't or couldn't fix the selections placement, the offset is in model space
        ace_repair_hitpointPositions[] = {{"HitEngine", {0,-2,0}}};

        // Disable vanilla repair on the vehicle if it's enabled, not needed otherwise
        transportRepair = 0;
    };
};
```
