inhibit_all_warnings!

def import_common_pods
    pod 'Ono'
end

def import_ios_pods

end

def import_osx_pods

end

target :'SKTiledMap', :exclusive => true do
    platform :ios, '8.0'
    import_common_pods
	import_ios_pods
end

target :'SKTiledMap-Mac', :exclusive => true do
    platform :osx, '10.10'
    import_common_pods
    import_osx_pods
end
