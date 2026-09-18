enum ResourceTypeEnum { photo, video, website }

ResourceTypeEnum resourceTypeFromString(String type) {
  return ResourceTypeEnum.values.firstWhere(
    (e) => e.name.toLowerCase() == type.toLowerCase(),
    orElse: () => ResourceTypeEnum.website, // fallback if nothing matches
  );
}
