package com.elearning.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryConfig {
    private static Cloudinary cloudinary;

    public static Cloudinary getInstance() {
        if (cloudinary == null) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dl8wn0uih",
                "api_key",    "662678514692777",
                "api_secret", "mGZ8hGMi3hTwwTrdWx70DlMl4Ac"
            ));
        }
        return cloudinary;
    }
}