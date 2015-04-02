require 'puppet/property/boolean'
Puppet::Type.newtype(:chronos_job) do

    @doc = "Manage creation/deletion of Chronos jobs."

    ensurable

    newparam(:name, :namevar => true) do
        desc "The name of the Chronos job."
    end

    # It is way simpler to support localhost only.
    newparam(:host) do
        desc "The host/port to the chronos host. Defaults to localhost."
        defaultto 'http://localhost:4400'
    end

    newproperty(:command) do
        desc "The command to execute in the job."
        validate do |val|
            unless val.is_a? String
                raise ArgumentError, "epsilon parameter must be a String, got value of type #{val.class}"
            end
        end
    end

    newproperty(:job_schedule) do
        desc "The scheduling for the job, in ISO8601 format."
        validate do |val|
            unless val.is_a? String
                raise ArgumentError, "schedule parameter must be a String, got value of type #{val.class}"
            end
        end
    end

    newproperty(:schedule_timezone) do
        desc "The time zone name to use when scheduling the job."
        defaultto 'UTC'
        validate do |val|
            if not val.is_a? String
                raise ArgumentError, "schedule_timezone parameter must be a String, got value of type #{val.class}"
            end
        end
    end

    newproperty(:epsilon) do
        desc "The interval to run the job on, in ISO8601 duration format."
        validate do |val|
            unless val.is_a? String
                raise ArgumentError, "epsilon parameter must be a String, got value of type #{val.class}"
            end
        end
    end

    newproperty(:owner) do
        desc "The email address of the person or persons interested in the job status."
        # Should we validate against http://www.ex-parrot.com/~pdw/Mail-RFC822-Address.html...?
        validate do |val|
            unless val.is_a? String
                raise ArgumentError, "owner parameter must be a String, got value of type #{val.class}"
            end
        end
    end

    newproperty(:async, :boolean => true, :parent => Puppet::Property::Boolean) do
        desc "Whether or not the job runs in the background."
    end

    newproperty(:parents) do
        desc "Optionally associate with parent Chronos job(s)."
        munge do |value|
          value.to_a
      end
    end

    newproperty(:retries) do
      desc "Number of times to retry job execution after a failure."
      validate do |val|
        unless val.is_a? Fixnum
          raise ArgumentError, "retries parameter must be a Fixnum, got value of type #{val.class}"
        end
      end
    end

    autorequire(:chronos_job) do
      parent_jobs = self[:parents]
    end
end
