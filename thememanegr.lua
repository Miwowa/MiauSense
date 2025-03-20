--\\ not my code
--\\ yes we use a changed linoria its like 70% recoded thou
local cloneref = (cloneref or clonereference or function(instance: any) return instance end)
local httpService = cloneref(game:GetService('HttpService'))
local httprequest = (syn and syn.request) or request or http_request or (http and http.request)
local getassetfunc = getcustomasset or getsynasset
local isfolder, isfile, listfiles = isfolder, isfile, listfiles;
if typeof(copyfunction) == "function" then
    local
        isfolder_copy,
        isfile_copy,
        listfiles_copy = copyfunction(isfolder), copyfunction(isfile), copyfunction(listfiles);
    local isfolder_success, isfolder_error = pcall(function()
        return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
    end);
    if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
        isfolder = function(folder)
            local success, data = pcall(isfolder_copy, folder)
            return (if success then data else false)
        end;
        isfile = function(file)
            local success, data = pcall(isfile_copy, file)
            return (if success then data else false)
        end;
        listfiles = function(folder)
            local success, data = pcall(listfiles_copy, folder)
            return (if success then data else {})
        end;
    end
end
local ThemeManager = {} do
    ThemeManager.Folder = 'LinoriaLibSettings'
    ThemeManager.Library = nil
    function ThemeManager:SetLibrary(library)
        self.Library = library
    end
    function ThemeManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end
    function ThemeManager:BuildFolderTree()
        local paths = self:GetPaths()

        for i = 1, #paths do
            local str = paths[i]
            if isfolder(str) then continue end
            makefolder(str)
        end
    end
    function ThemeManager:GetPaths()
        local paths = {}
        local parts = self.Folder:split('/')
        for idx = 1, #parts do
            paths[#paths + 1] = table.concat(parts, '/', 1, idx)
        end
        paths[#paths + 1] = self.Folder .. '/themes'
        return paths
    end
    function ThemeManager:ThemeUpdate()
        if self.Library then
            self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
            self.Library:UpdateColorsUsingRegistry()
        end
    end
    function ThemeManager:CreateThemeManager(groupbox)
        groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor })
        self.Library.Options.AccentColor:OnChanged(function()
            self.Library.AccentColor = self.Library.Options.AccentColor.Value
            self:ThemeUpdate()
        end)
    end
    function ThemeManager:CreateGroupBox(tab)
        assert(self.Library, 'Must set ThemeManager.Library first!')
        return tab:AddLeftGroupbox('Themes')
    end
    function ThemeManager:ApplyToTab(tab)
        assert(self.Library, 'Must set ThemeManager.Library first!')
        local groupbox = self:CreateGroupBox(tab)
        self:CreateThemeManager(groupbox)
    end
    function ThemeManager:ApplyToGroupbox(groupbox)
        assert(self.Library, 'Must set ThemeManager.Library first!')
        self:CreateThemeManager(groupbox)
    end
    ThemeManager:BuildFolderTree()
end
getgenv().LinoriaThemeManager = ThemeManager
return ThemeManager
