local orig_print = print
if Mods.mrudat_TestingMods then
  print = orig_print
else
  print = empty_func
end

local CurrentModId = rawget(_G, 'CurrentModId') or rawget(_G, 'CurrentModId_X')
local CurrentModDef = rawget(_G, 'CurrentModDef') or rawget(_G, 'CurrentModDef_X')
if not CurrentModId then

  -- copied shamelessly from Expanded Cheat Menu
  local Mods, rawset = Mods, rawset
  for id, mod in pairs(Mods) do
    rawset(mod.env, "CurrentModId_X", id)
    rawset(mod.env, "CurrentModDef_X", mod)
  end

  CurrentModId = CurrentModId_X
  CurrentModDef = CurrentModDef_X
end

orig_print("loading", CurrentModId, "-", CurrentModDef.title)

-- unforbid SubsurfaceHeaters from being built inside.
mrudat_AllowBuildingInDome.forbidden_template_classes.SubsurfaceHeater = nil

local wrap_method = mrudat_AllowBuildingInDome.wrap_method

mrudat_AllowBuildingInDome.DomePosOrMyPos('SubsurfaceHeater')

wrap_method('SubsurfaceHeater', 'GetHeatCenter', function(self, orig_method)
  local dome = self.parent_dome
  if not dome then
    return orig_method(self)
  end

  return dome:GetVisualPosXYZ()
end)

wrap_method('SubsurfaceHeater','UpdateElectricityConsumption', function(self, orig_method)
  local dome = self.parent_dome
  if not dome then
    return orig_method(self)
  end

  local range = self.UIRange

  local base_range = self:GetPropertyMetadata("UIRange").base

  if base_range == nil then
    print("Argh!")
  end

  local template = ClassTemplates.Building[self.template_name]
  self:SetBase("electricity_consumption", MulDivRound(range * range, template.electricity_consumption, base_range * base_range))
end)

local prop_cache = {}

wrap_method('SubsurfaceHeater','GetPropertyMetadata', function(self, orig_method, prop_name)
  if prop_name ~= "UIRange" then
    return orig_method(self, prop_name)
  end

  local dome = self.parent_dome
  if not dome then
    return orig_method(self, prop_name)
  end

  local prop = prop_cache[dome]

  if prop then return prop end

  prop = orig_method(self, prop_name)
  prop = table.copy(prop)

  local dome_radius = HexShapeRadius(dome:GetInteriorShape())

  local dome_work_radius = dome:GetOutsideWorkplacesDist()

  prop.base = prop.min
  prop.default = dome_radius
  prop.min = dome_radius
  prop.max = dome_work_radius

  prop_cache[dome] = prop
  print(prop)
  return prop
end)

function SavegameFixups.mrudat_IndomeSubsurfaceHeater_RestartHeaters()
  for _, heater in pairs(UICity.labels.SubsurfaceHeater or empty_table) do
    if not heater.parent_dome then
      if heater.working then
        heater:ApplyHeat(true)
      end
    end
  end
end

orig_print("loaded", CurrentModId, "-", CurrentModDef.title)
