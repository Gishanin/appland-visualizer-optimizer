class AppmapJson < ApplicationRecord
  enum status: {
    not_optimazed: 0,
    optimazed: 1
  }
end
