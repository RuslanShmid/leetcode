require 'pry'

def remove_element(nums, val)
  k = nums.length
  nums.length.times do |index|
    while nums[index] == val
      nums.append('_')
      nums.delete_at(index)
      k -= 1
    end
  end
  k
end

# nums = [0, 1, 2, 2, 3, 0, 4, 2]
# val = 2
#
nums = [4, 5]
val = 5
#
# 5, nums = [0,1,4,0,3,_,_,_]
print remove_element(nums, val)
binding.pry
