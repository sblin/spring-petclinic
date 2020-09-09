FROM openjdk:8-jre
ADD target/petclinic.jar /usr/local
WORKDIR /usr/local
CMD ["java" , "-jar","petclinic.jar" ]