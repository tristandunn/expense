Before do
  Timecop.freeze(Time.utc(2010, 6, 2, 4, 0, 0))
end

After do
  Timecop.return
end
