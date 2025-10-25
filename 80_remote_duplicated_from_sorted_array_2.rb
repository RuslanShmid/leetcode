require 'pry'

def remove_duplicates(nums)
  l = nums.length
  index = 0
  until nums[index].nil?
    nums.delete_at(index + 2) while nums[index] == nums[index + 1] && nums[index + 1] == nums[index + 2]
    index += 1
  end
  index
end

nums = [0, 0, 1, 1, 1, 1, 2, 3, 3]

remove_duplicates(nums)
binding.pry
