def test_lane
    scan(
      project: "AccountsListTCA.xcodeproj",
      scheme: "AccountsListTCA",
      clean: true,
      devices: ["iPhone 16"],
      code_coverage: true,
      result_bundle: true,
      buildlog_path: "fastlane/logs"
    )
end
