package com.elearning.dao;

import com.elearning.model.Course;
import com.elearning.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    public boolean addCourse(Course course) {
        String sql = "INSERT INTO courses (title, description, instructor_id, thumbnail_url, category) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getInstructorId());
            ps.setString(4, course.getThumbnailUrl());
            ps.setString(5, course.getCategory());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, u.name as instructor_name FROM courses c LEFT JOIN users u ON c.instructor_id = u.id ORDER BY c.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setInstructorId(rs.getInt("instructor_id"));
                c.setInstructorName(rs.getString("instructor_name"));
                c.setThumbnailUrl(rs.getString("thumbnail_url"));
                c.setCategory(rs.getString("category"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                courses.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return courses;
    }

    public boolean enrollStudent(int studentId, int courseId) {
        String checkSql = "SELECT id FROM enrollments WHERE student_id = ? AND course_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement checkPs = con.prepareStatement(checkSql)) {
            checkPs.setInt(1, studentId);
            checkPs.setInt(2, courseId);
            if (checkPs.executeQuery().next()) return false;
            String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Course> getEnrolledCourses(int studentId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.*, u.name as instructor_name FROM courses c JOIN enrollments e ON c.id = e.course_id LEFT JOIN users u ON c.instructor_id = u.id WHERE e.student_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setInstructorName(rs.getString("instructor_name"));
                c.setThumbnailUrl(rs.getString("thumbnail_url"));
                c.setCategory(rs.getString("category"));
                courses.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return courses;
    }

    public boolean deleteCourse(int courseId) {
        String sql = "DELETE FROM courses WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int getTotalCourses() {
        String sql = "SELECT COUNT(*) FROM courses";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}