package com.elearning.dao;

import com.elearning.util.DBConnection;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class ProgressDAO {

    public boolean updateProgress(int studentId, int courseId, int progress) {
        String sql = "UPDATE enrollments SET progress = ? WHERE student_id = ? AND course_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, progress);
            ps.setInt(2, studentId);
            ps.setInt(3, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public Map<String, Integer> getProgressByStudent(int studentId) {
        Map<String, Integer> progressMap = new LinkedHashMap<>();
        String sql = "SELECT c.title, e.progress FROM enrollments e JOIN courses c ON e.course_id = c.id WHERE e.student_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                progressMap.put(rs.getString("title"), rs.getInt("progress"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return progressMap;
    }

    public int getOverallProgress(int studentId) {
        String sql = "SELECT COALESCE(AVG(progress), 0) FROM enrollments WHERE student_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}