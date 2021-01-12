local reassemble_state = {}

function reassemble_cri_logs(tag, timestamp, record)
   local reassemble_key = tag
   if record.logtag == 'P' then
      reassemble_state[reassemble_key] = reassemble_state[reassemble_key] or "" .. record.log
      return -1, 0, 0
   end
   record.log = reassemble_state[reassemble_key] or "" .. (record.log or "")
   reassemble_state[reassemble_key] = nil
   return 1, timestamp, record
end

function nest_k8s_ns(tag, timestamp, record)
    if not record['kubernetes']['namespace_name'] then
        return 0, 0, 0
    end
    new_record = {}
    for key, val in pairs(record) do
        if key == 'kube' then
            new_record[key] = {}
            new_record[key][record['kubernetes']['namespace_name']] = record[key]
        else
            new_record[key] = record[key]
        end
    end
    return 1, timestamp, new_record
end
