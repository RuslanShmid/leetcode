require 'pry'

def merge(nums1, m, nums2, n)
  i = m - 1
  j = n - 1
  k = m + n - 1

  while j >= 0
    if i >= 0 && nums1[i] > nums2[j]
      nums1[k] = nums1[i]
      i -= 1
    else
      nums1[k] = nums2[j]
      j -= 1
    end
    k -= 1
  end
end

nums1 = [1, 2, 3, 0, 0, 0]
m = 3
nums2 = [2, 5, 6]
n = 3
puts merge(nums1, m, nums2, n)
print nums1
# [1,2,2,3,5,6]
# Explanation: The arrays we are merging are [1,2,3] and [2,5,6].
# The result of the merge is [1,2,2,3,5,6] with the underlined elements coming from nums1.
