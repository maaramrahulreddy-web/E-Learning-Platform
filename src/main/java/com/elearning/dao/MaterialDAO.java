package com.elearning.dao;

import com.elearning.model.CourseMaterial;
import com.elearning.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaterialDAO {

    public boolean addMaterial(CourseMaterial material) {
        String sql = "INSERT INTO course_materials (course_id, title, file_url, file_type, cloudinary_public_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, material.getCourseId());
            ps.setString(2, material.getTitle());
            ps.setString(3, material.getFileUrl());
            ps.setString(4, material.getFileType());
            ps.setString(5, material.getCloudinaryPublicId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<CourseMaterial> getMaterialsByCourse(int courseId) {
        List<CourseMaterial> list = new ArrayList<>();
        String sql = "SELECT cm.*, c.title as course_title FROM course_materials cm JOIN courses c ON cm.course_id = c.id WHERE cm.course_id = ? ORDER BY cm.uploaded_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CourseMaterial m = new CourseMaterial();
                m.setId(rs.getInt("id"));
                m.setCourseId(rs.getInt("course_id"));
                m.setCourseTitle(rs.getString("course_title"));
                m.setTitle(rs.getString("title"));
                m.setFileUrl(rs.getString("file_url"));
                m.setFileType(rs.getString("file_type"));
                m.setCloudinaryPublicId(rs.getString("cloudinary_public_id"));
                m.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(m);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<CourseMaterial> getAllMaterials() {
        List<CourseMaterial> list = new ArrayList<>();
        String sql = "SELECT cm.*, c.title as course_title FROM course_materials cm JOIN courses c ON cm.course_id = c.id ORDER BY cm.uploaded_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                CourseMaterial m = new CourseMaterial();
                m.setId(rs.getInt("id"));
                m.setCourseId(rs.getInt("course_id"));
                m.setCourseTitle(rs.getString("course_title"));
                m.setTitle(rs.getString("title"));
                m.setFileUrl(rs.getString("file_url"));
                m.setFileType(rs.getString("file_type"));
                m.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(m);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean deleteMaterial(int materialId) {
        String sql = "DELETE FROM course_materials WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, materialId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getTotalMaterials() {
        String sql = "SELECT COUNT(*) FROM course_materials";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}