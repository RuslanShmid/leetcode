require 'pry'

def remove_duplicates(nums)
  l = nums.length
  index = 0
  until nums[index].nil?
    nums.delete_at(index + 1) while nums[index] == nums[index + 1]
    index += 1
  end
  index
end

nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]

remove_duplicates(nums)
binding.pry
