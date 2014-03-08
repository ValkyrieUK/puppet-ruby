Puppet::Type.newtype(:ruby) do

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:installed)

    aliasvalue(:installed, :present)
    aliasvalue(:uninstalled, :absent)
  end

  newparam(:environment) do
    validate do |value|
      unless value.is_a? Hash
        raise Puppet::ParseError,
          "Expected environment to be a Hash, got #{value.class.name}"
      end
    end
  end

  newparam(:prefix) do
    validate do |value|
      unless value.is_a? String
        raise Puppet::ParseError,
          "Expected prefix to be a String, got #{value.class.name}"
      end
    end
  end

  newparam(:version) do
    isnamevar

    validate do |value|
      unless value.is_a? String
        raise Puppet::ParseError,
          "Expected prefix to be a String, got #{value.class.name}"
      end
    end
  end

  newparam(:user) do
    defaultto Facter.value(:id)
  end

  newparam(:ruby_build) do
    validate do |value|
      unless value.is_a? String
        raise Puppet::ParseError,
          "Expected ruby_build to be a String, got #{value.class.name}"
      end
    end
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end

  autorequire :file do
    Array.new.tap do |a|
      if @parameters.include?(:prefix) && prefix = @parameters[:prefix].to_s
        a << prefix if catalog.resource(:file, prefix)
      end
    end
  end

end